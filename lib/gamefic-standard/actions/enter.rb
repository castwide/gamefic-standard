Gamefic.script do
  respond :enter, siblings do |actor, thing|
    actor.tell "#{The thing} can't accommodate you."
  end

  respond :enter, siblings(Enterable, :enterable?) do |actor, supporter|
    actor.parent = supporter
    actor.tell "You get in #{the supporter}."
  end

  respond :enter, parent do |actor, container|
    actor.tell "You're already in #{the container}."
  end

  respond :enter, parent(Supporter) do |actor, supporter|
    actor.tell "You're inside #{the supporter} already."
  end

  respond :enter, siblings(Container, :enterable?, :closed?) do |actor, container|
    actor.tell "#{The container} is closed."
  end

  interpret "get on :thing", "enter :thing"
  interpret "get in :thing", "enter :thing"
end
