class Gamefic::Query::Room < Gamefic::Query::Base
  def span subject
    [subject.room].compact
  end
end

# @todo Monkey patch
module Gamefic::Scriptable::Queries
  def room *args
    Gamefic::Query::Room.new(Room, *args, name: 'room')
  end
end
