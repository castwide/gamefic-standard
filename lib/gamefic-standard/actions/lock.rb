module Gamefic
  module Standard
    script do
      respond :lock, available do |actor, thing|
        actor.tell "You can't lock #{the thing}."
      end

      respond :lock, available(Lockable, proc(&:has_lock_key?)), children do |actor, thing, key|
        if thing.lock_key == key
          thing.locked = true
          actor.tell "You lock ##{the thing} with #{the key}."
        else
          actor.tell "You can't lock #{the thing} with #{the key}."
        end
      end

      respond :lock, available(Lockable, proc(&:has_lock_key?)), available do |actor, thing, key|
        actor.execute :take, key if key.parent != actor
        actor.proceed if key.parent == actor
      end

      interpret "lock :container with :key", "lock :container :key"
    end
  end
end
