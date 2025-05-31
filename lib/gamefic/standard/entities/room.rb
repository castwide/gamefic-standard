# frozen_string_literal: true

module Gamefic
  module Standard
    # An entity that represents a location in the game world that other
    # entities can occupy.
    #
    class Room < Thing
      attr_writer :explicit_exits

      set_default explicit_exits: true

      def explicit_exits?
        @explicit_exits
      end

      def tell(message)
        children.each { |c| c.tell message }
      end

      # @return [Array<Portal>]
      def portals
        children.that_are(Portal)
      end

      # @param destination [Room]
      # @param direction [Direction, String, nil]
      # @param type [Class<Portal>]
      # @param two_way [Boolean]
      # @return [Portal, Array<Portal>]
      def connect(destination, direction: nil, type: Portal, two_way: true, **opts)
        direction = Direction.find(direction)
        here = type.new parent: self, destination: destination, direction: direction, **opts
        return here unless two_way

        there = type.new parent: destination, destination: self, direction: direction&.reverse, **opts
        [here, there]
      end

      protected

      Direction.names.each do |direction|
        define_method "#{direction}=" do |destination|
          connect destination, direction: direction
        end
      end

      def connect=(definitions)
        all = [definitions].flatten
        until all.empty?
          definition = all.shift
          if definition.is_a?(Hash)
            connect definition[:destination], **definition.except(:destination)
          else
            # @todo Prefer definition hashes
            direction = (all.first.is_a?(String) ? all.shift : nil)
            connect definition, direction: direction
          end
        end
      end

      # @todo Candidate for deprecation
      def one_way=(destinations)
        [destinations].flatten.each do |destination|
          connect destination, two_way: false
        end
      end
    end
  end
end
