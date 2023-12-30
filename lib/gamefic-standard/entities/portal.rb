# frozen_string_literal: true

class Portal < Thing
  # @return [Gamefic::Entity]
  attr_accessor :destination

  # Get the ordinal direction of this Portal
  # Portals have distinct direction and name properties so games can display a
  # bare compass direction for exits, e.g., "south" vs. "the southern door."
  #
  # A portal's destination can also be nil, in which case it can be referenced
  # in commands by its destination, e.g., "go to the house."
  #
  # @return [Direction, nil]
  attr_reader :direction

  # Find the portal in the destination that returns to this portal's parent
  #
  # @return [Room, nil]
  def reverse
    return nil if destination.nil?
    destination.children.that_are(Portal).find do |portal|
      portal.destination == parent
    end
  end
  alias find_reverse reverse

  def direction= dir
    @direction = Direction.find(dir)
  end

  def name
    @name || (direction.nil? ? destination.name : direction.name)
  end

  def instruction
    direction || (destination ? "to #{destination.definitely}" : name)
  end

  def synonyms
    "#{super} #{@destination} #{@direction} #{!direction.nil? ? direction.synonyms : ''}"
  end
end
