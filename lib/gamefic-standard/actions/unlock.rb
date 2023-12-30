Gamefic::Standard.script do
  respond :unlock, available(Lockable) do |actor, thing|
    if thing.has_lock_key? && actor.children.include?(thing.lock_key)
      actor.execute :unlock, thing, thing.lock_key
    else
      actor.tell "You can't unlock #{the thing}."
    end
  end

  respond :unlock, available(Lockable, proc(&:has_lock_key?)), children do |actor, thing, key|
    if thing.lock_key == key
      thing.locked = false
      actor.tell "You unlock #{the thing} with #{the key}."
    else
      actor.tell "You can't unlock #{the thing} with #{the key}."
    end
  end

  respond :unlock, available(Lockable, proc(&:has_lock_key?)), available do |actor, _thing, key|
    actor.execute :take, key if key.parent != actor
    actor.proceed if key.parent == actor
  end

  interpret "unlock :container with :key", "unlock :container :key"
end
