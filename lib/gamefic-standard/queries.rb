class Gamefic::Scope::Room < Gamefic::Scope::Base
  def matches
    [context.room].compact
  end
end

module Gamefic::Standard::Queries
  def room *args
    Gamefic::Query::Scoped.new Gamefic::Scope::Room, *([Room] + args)
  end
end

Gamefic::Standard.include Gamefic::Standard::Queries
