class Portal < Thing
  # @return [Gamefic::Entity]
  attr_accessor :destination

  # Find the portal in the destination that returns to this portal's parent
  #
  # @return [Room, nil]
  def find_reverse
    return nil if destination.nil?
    destination.children.that_are(Portal).find do |portal|
      portal.destination == parent
    end
  end

  # Get the ordinal direction of this Portal
  # Portals have distinct direction and name properties so games can display a
  # bare compass direction for exits, e.g., "south" vs. "the southern door."
  #
  # @return [Direction]
  def direction
    @direction
  end

  def direction= d
    @direction = Direction.find(d)
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
