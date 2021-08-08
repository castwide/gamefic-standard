Gamefic.script do
  respond :search, Use.available(Thing) do |actor, thing|
    actor.perform :look, thing
  end

  respond :search, Use.available(Receptacle) do |actor, thing|
    if thing.accessible?
      itemized = thing.children.that_are_not(:attached?).that_are(:itemized?)
      if itemized.empty?
        actor.tell "There's nothing inside #{the thing}."
      else
        actor.tell "You see #{itemized.join_and} in #{the thing}." unless itemized.empty?
      end
    else
      actor.tell "You can't see inside #{the thing}."
    end
  end

  respond :search, Use.available(Container, :closed?) do |actor, container|
    actor.perform :open, container
    actor.proceed if container.open?
  end

  interpret 'look inside :thing', 'search :thing'
  interpret 'look in :thing', 'search :thing'
end
