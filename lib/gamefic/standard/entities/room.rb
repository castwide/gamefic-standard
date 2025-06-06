# frozen_string_literal: true

module Gamefic
  module Standard
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
        here = type.new parent: self, destination: destination, direction: Direction.find(direction), **opts
        return here unless two_way

        there = type.new parent: destination, destination: self, direction: direction&.reverse, **opts
        [here, there]
      end

      protected

      %w[north south west east northeast southeast southwest northwest up down].each do |direction|
        define_method "#{direction}=" do |destination|
          connect destination, direction: direction
        end
      end

      def connect=(destinations)
        all = [destinations].flatten
        until all.empty?
          destination = all.shift
          direction = (all.first.is_a?(String) ? all.shift : nil)
          connect destination, direction: direction
        end
      end

      def one_way=(destinations)
        [destinations].flatten.each do |destination|
          connect destination, two_way: false
        end
      end
    end
  end
end
