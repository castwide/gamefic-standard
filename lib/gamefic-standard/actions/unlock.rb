Gamefic.script do
  respond :unlock, Use.available do |actor, thing|
    actor.tell "You can't unlock #{the thing}."
  end

  respond :unlock, Use.available(Lockable, :has_lock_key?), Use.children do |actor, thing, key|
    if thing.lock_key == key
      thing.locked = false
      actor.tell "You unlock ##{the thing} with #{the key}."
    else
      actor.tell "You can't unlock #{the thing} with #{the key}."
    end
  end

  respond :unlock, Use.available(Lockable, :has_lock_key?), Use.available do |actor, _thing, key|
    actor.perform :take, key if key.parent != actor
    actor.proceed if key.parent == actor
  end

  interpret "unlock :container with :key", "unlock :container :key"
end
