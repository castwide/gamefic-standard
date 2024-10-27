module Gamefic
  module Standard
    module Queries
      class RoomQuery < Gamefic::Query::Base
        def span(subject)
          [subject.room].compact
        end
      end

      def room *args
        RoomQuery.new(Room, *args, name: 'room')
      end
    end
  end
end

# @todo Monkey patch
module Gamefic::Scriptable::Queries
  include Gamefic::Standard::Queries
end
