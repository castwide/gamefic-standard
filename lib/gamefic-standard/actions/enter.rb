Gamefic.script do
  respond :enter, Use.siblings do |actor, thing|
    actor.tell "#{The thing} can't accommodate you."
  end

  respond :enter, Use.siblings(Enterable, :enterable?) do |actor, supporter|
    actor.parent = supporter
    actor.tell "You get in #{the supporter}."
  end

  respond :enter, Use.parent do |actor, container|
    actor.tell "You're already in #{the container}."
  end

  respond :enter, Use.parent(Supporter) do |actor, supporter|
    actor.tell "You're inside #{the supporter} already."
  end

  interpret "get on :thing", "enter :thing"
  interpret "get in :thing", "enter :thing"
end
