# frozen_string_literal: true

module Gamefic
  module Standard
    # Pathfinders provide the shortest route between two rooms. The destination
    # needs to be accessible from the origin through portals. Note that
    # Pathfinder does not take into account portals that characters should not
    # be able to traverse, such as locked doors.
    #
    class Pathfinder
      # @return [Room]
      attr_reader :origin

      # @return [Room]
      attr_reader :destination

      # @param origin [Room]
      # @param destination [Room]
      def initialize(origin, destination)
        @origin = origin
        @destination = destination
        @visited = []
        if origin == destination
          @path = []
        else
          embark [[origin]]
        end
      end

      # An array of rooms starting with the first room after the origin and
      # ending with the destination.
      #
      # The path will be empty if a path could not be found or the origin and
      # destination are the same room.
      #
      # @return [Array<Room>]
      def path
        @path || []
      end

      # True if there is a valid path from the origin to the destination (or
      # the origin and destination are the same room).
      #
      def valid?
        !!@path
      end

      private

      def embark(paths)
        return if paths.empty?

        new_paths = paths.each_with_object([]) do |path, acc|
          updates = traverse(path)
          acc.concat updates
        end

        if new_paths.last&.last == destination
          @path = new_paths.last
        else
          embark new_paths
        end
      end

      def traverse(path)
        portals_with_destination(path).map do |portal|
          next if @visited.include?(portal.destination)

          return [path[1..] + [portal.destination]] if portal.destination == destination

          @visited.push portal.destination
          path + [portal.destination]
        end
        .compact
      end

      def portals_with_destination(path)
        path.last.children.that_are(Portal).select(&:destination)
      end
    end
  end
end
