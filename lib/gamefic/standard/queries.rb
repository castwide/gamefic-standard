module Gamefic
  module Standard
    module Queries
      class RoomQuery < Gamefic::Query::Base
        def span(subject)
          [subject.room].compact
        end
      end
    end
  end
end

# @todo Monkey patch
module Gamefic
  module Scriptable
    module Queries
      include Gamefic::Standard::Queries

      def room *args
        RoomQuery.new(Gamefic::Standard::Room, *args, name: 'room')
      end
    end
  end
end
