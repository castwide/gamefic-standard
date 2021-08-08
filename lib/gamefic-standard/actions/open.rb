Gamefic.script do
  respond :open, Use.available do |actor, thing|
    actor.tell "You can't open #{the thing}."
  end

  respond :open, Use.available(Openable) do |actor, thing|
    if thing.open?
      actor.tell "#{The thing} is already open."
    else
      actor.tell "You open #{the thing}."
      thing.open = true
    end
  end

  respond :open, Use.available(Lockable) do |actor, thing|
    if thing.locked?
      actor.tell "#{The thing} is locked."
    else
      actor.proceed
    end
  end

  respond :open, Use.available(Lockable, :has_lock_key?), Use.available do |actor, thing, key|
    actor.perform :unlock, thing, key
    actor.perform :open, thing if thing.unlocked?
  end

  interpret 'open :thing with :key', 'open :thing :key'
end
