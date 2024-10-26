# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Search
        extend Gamefic::Scriptable

        respond :search, available(Thing) do |actor, thing|
          actor.execute :look, thing
        end

        respond :search, available(Receptacle) do |actor, thing|
          if thing.accessible?
            itemized = thing.children.that_are_not(proc(&:attached?)).that_are(proc(&:itemized?))
            if itemized.empty?
              actor.tell "There's nothing inside #{the thing}."
            else
              actor.tell "You see #{itemized.join_and} in #{the thing}." unless itemized.empty?
            end
          else
            actor.tell "You can't see inside #{the thing}."
          end
        end

        respond :search, available(Container, proc(&:closed?)) do |actor, container|
          actor.execute :open, container
          actor.proceed if container.open?
        end

        interpret 'look inside :thing', 'search :thing'
        interpret 'look in :thing', 'search :thing'
      end
    end
  end
end
