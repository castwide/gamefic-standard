module Gamefic
  module Standard
    # Descriptions of the geographical relationships between entities. Portals
    # can use directions to identify the path to their destination, such as
    # north, southwest, up, etc.
    #
    class Direction
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
        # @return [Hash{Symbol => Direction}]
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
            down: Direction.new(name: 'down', adjective: 'downwards', reverse: :up),
            in: Direction.new(name: 'in', adjective: 'inside', reverse: :out),
            out: Direction.new(name: 'in', adjective: 'inside', reverse: :in)
          }
        end

        def names
          compass.values.map(&:name)
        end

        # @param dir [Direction, String, Symbol]
        # @return [Direction, nil]
        def find(dir)
          return dir if dir.is_a?(Direction)

          compass[dir.to_s.downcase.to_sym]
        end
      end

      NORTH = compass[:north]
      SOUTH = compass[:south]
      WEST = compass[:west]
      EAST = compass[:east]
      NORTHWEST = compass[:northwest]
      SOUTHEAST = compass[:southeast]
      NORTHEAST = compass[:northeast]
      SOUTHWEST = compass[:southwest]
      UP = compass[:up]
      DOWN = compass[:down]
      IN = compass[:in]
      OUT = compass[:out]
    end
  end
end
