# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Lock
        extend Gamefic::Scriptable

        respond :lock, available do |actor, thing|
          actor.tell "You can't lock #{the thing}."
        end

        respond :lock, available(Lockable) do |actor, thing|
          if thing.has_lock_key? && actor.children.include?(thing.lock_key)
            actor.execute :lock, thing, thing.lock_key
          else
            actor.tell "You can't lock #{the thing}."
          end
        end

        respond :lock, available(Lockable, proc(&:has_lock_key?)), children do |actor, thing, key|
          if thing.lock_key == key
            if thing.locked?
              actor.tell "It's already locked."
            else
              thing.locked = true
              actor.tell "You lock #{the thing} with #{the key}."
            end
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
end
