class Gamefic::Scope::Room < Gamefic::Scope::Base
  def matches
    [context.room].compact
  end

  def self.precision
    1000
  end
end

module Gamefic::Delegatable::Queries
  def room *args
    Gamefic::Query::Scoped.new Gamefic::Scope::Room, *args
  end
end
