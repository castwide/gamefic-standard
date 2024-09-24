class Gamefic::Scope::Room < Gamefic::Scope::Base
  def matches
    [context.room].compact
  end
end

# @todo Monkey patch
module Gamefic::Scriptable::Queries
  def room *args
    Gamefic::Query::Scoped.new Gamefic::Scope::Room, *([Gamefic::Standard::Room] + args)
  end
end
