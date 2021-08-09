Gamefic.script do
  respond :drop, Use.available do |actor, thing|
    actor.tell "You're not carrying #{the thing}."
  end

  respond :drop, Gamefic::Query::Descendants.new do |actor, thing|
    actor.perform :take, thing
    next unless thing.parent == actor
    thing.parent = actor.parent
    actor.tell "You drop #{the thing}."
  end

  respond :drop, Use.children do |actor, thing|
    thing.parent = actor.parent
    actor.tell "You drop #{the thing}."
  end

  interpret "put down :thing", "drop :thing"
  interpret "put :thing down", "drop :thing"
end
