Gamefic.script do
  respond :lock, Use.available do |actor, thing|
    actor.tell "You can't lock #{the thing}."
  end

  respond :_toggle_lock, Use.available(Lockable, :has_lock_key?) do |actor, thing|
    verb = thing.locked? ? 'unlock' : 'lock'
    key = nil
    if thing.lock_key.parent == actor
      key = thing.lock_key
    end
    if key.nil?
      actor.tell "You don't have any way to #{verb} #{the thing}."
    else
      actor.tell "You #{verb} #{the thing} with #{the key}."
      thing.locked = !thing.locked?
    end
  end

  respond :lock, Use.available(Lockable, :has_lock_key?), Use.children do |actor, thing, key|
    if thing.lock_key == key
      actor.perform :_toggle_lock, thing
    else
      actor.tell "You can't unlock #{the thing} with #{the key}."
    end
  end

  respond :lock, Use.available(Lockable, :has_lock_key?), Use.available do |actor, thing, key|
    actor.perform :take, key if key.parent != actor
    actor.proceed if key.parent == actor
  end

  respond :unlock, Use.available do |actor, thing|
    actor.tell "You can't unlock #{the thing}."
  end

  respond :unlock, Use.available(Lockable, :has_lock_key?), Use.children do |actor, thing, key|
    if thing.lock_key == key
      actor.perform :_toggle_lock, thing
    else
      actor.tell "You can't unlock #{the thing} with #{the key}."
    end
  end

  respond :unlock, Use.available(Lockable, :has_lock_key?), Use.available do |actor, thing, key|
    actor.perform :take, key if key.parent != actor
    actor.proceed if key.parent == actor
  end

  interpret "lock :container with :key", "lock :container :key"
  interpret "unlock :container with :key", "unlock :container :key"
  interpret "open :container with :key", "unlock :container :key"
end
