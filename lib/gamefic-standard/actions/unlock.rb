Gamefic.script do
  respond :unlock, available do |actor, thing|
    actor.tell "You can't unlock #{the thing}."
  end

  respond :unlock, available(Lockable, proc(&:has_lock_key?)), children do |actor, thing, key|
    if thing.lock_key == key
      thing.locked = false
      actor.tell "You unlock ##{the thing} with #{the key}."
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
