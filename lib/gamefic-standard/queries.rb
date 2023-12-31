class Gamefic::Scope::Room < Gamefic::Scope::Base
  def matches
    [context.room].compact
  end
end

# @todo Monkey patch
module Gamefic::Delegatable::Queries
  def room *args
    Gamefic::Query::Scoped.new Gamefic::Scope::Room, *([Room] + args)
  end
end
