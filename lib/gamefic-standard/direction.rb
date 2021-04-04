class Direction
  include Gamefic::Serialize

  attr_writer :adjective, :adverb, :reverse

  # @return [String]
  attr_accessor :name

  def initialize **args
    args.each { |key, value|
      send "#{key}=", value
    }
  end

  # @return [String]
  def adjective
    @adjective || @name
  end

  # @return [String]
  def adverb
    @adverb || @name
  end

  # @return [String]
  def synonyms
    "#{adjective} #{adverb}"
  end

  def reverse
    Direction.find @reverse
  end

  def to_s
    @name
  end

  class << self
    def compass
      @compass ||= {
        north: Direction.new(name: 'north', adjective: 'northern', reverse: :south),
        south: Direction.new(name: 'south', adjective: 'southern', reverse: :north),
        west: Direction.new(name: 'west', adjective: 'western', reverse: :east),
        east: Direction.new(name: 'east', adjective: 'eastern', reverse: :west),
        northwest: Direction.new(name: 'northwest', adjective: 'northwestern', reverse: :southeast),
        southeast: Direction.new(name: 'southeast', adjective: 'southeastern', reverse: :northwest),
        northeast: Direction.new(name: 'northeast', adjective: 'northeastern', reverse: :southwest),
        southwest: Direction.new(name: 'southwest', adjective: 'southwestern', reverse: :northeast),
        up: Direction.new(name: 'up', adjective: 'upwards', reverse: :down),
        down: Direction.new(name: 'down', adjective: 'downwards', reverse: :up)
      }
    end

    # @param dir [Direction, string]
    # @return [Direction, nil]
    def find(dir)
      return dir if dir.is_a?(Direction)
      compass[dir.to_s.downcase.to_sym]
    end
  end
end
