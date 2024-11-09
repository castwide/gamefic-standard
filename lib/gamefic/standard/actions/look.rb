# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Look
        extend Gamefic::Scriptable

        def itemize_room(actor)
          return unless (room = actor.room)

          siblings = room.children.select(&:itemized?).that_are_not(actor)

          siblings.that_are(Character)
                  .reject(&:locale_description)
                  .tap do |list|
                    list.empty? or actor.tell "#{list.join_and.cap_first} #{list.one? ? 'is' : 'are'} here."
                  end

          siblings.that_are_not(Character, Portal)
                  .reject(&:locale_description)
                  .tap do |list|
                    list.empty? or actor.tell "You see #{list.join_and}."
                  end

          siblings.select(&:locale_description)
                  .each { |thing| actor.tell thing.locale_description }

          itemize_explicit_portals(actor)
          itemize_parent(actor) unless actor.parent == actor.room
        end

        def itemize_explicit_portals(actor)
          return unless actor.room&.explicit_exits?

          siblings = actor.room.children.select(&:itemized?).that_are_not(actor)
          earlier = siblings.select(&:locale_description).that_are(Portal).any?
          siblings.that_are(Portal)
                  .reject(&:locale_description)
                  .tap do |portals|
                    next if portals.empty?

                    if portals.one?
                      actor.tell "There is#{earlier ? ' also ' : ' '}an exit #{portals.first.instruction}."
                    else
                      order = %w[north northeast east southeast south southwest west northwest up down]
                      dirs = portals.map(&:instruction)
                                    .map(&:to_s)
                                    .sort { |a, b| order.index(a) || 0 <=> order.index(b) || 1 }
                      actor.tell "There are#{earlier ? ' also ' : ' '}exits #{dirs.join_and(', ')}."
                    end
                  end
        end

        def itemize_parent(actor)
          return unless (parent = actor.parent)

          preposition = parent.is_a?(Supporter) ? 'on' : 'in'
          siblings = parent.children.that_are_not(actor)
          if siblings.empty?
            actor.tell "You're #{preposition} #{the parent}."
          else
            actor.tell "You're #{preposition} #{the parent}, along with #{siblings.join_and}."
          end
        end

        respond :look do |actor|
          if actor.room
            actor.execute :look, actor.room
          else
            actor.tell "You're in a featureless void."
          end
        end

        respond :look, myself do |actor, _|
          actor.tell actor.description
          actor.execute :inventory
        end

        respond :look, available(Thing) do |actor, thing|
          actor.tell thing.description
          thing.children.that_are(proc(&:attached?)).that_are(proc(&:itemized?)).each do |item|
            actor.tell "#{An item} is attached to #{the thing}."
          end
        end

        respond :look, available(Supporter) do |actor, thing|
          itemized = thing.children.that_are_not(proc(&:attached?)).that_are(proc(&:itemized?))
          # If the supporter does not have a description but it does contain
          # itemized things, avoid saying there's nothing special about it.
          actor.proceed if thing.has_description? || itemized.empty?
          actor.tell "You see #{itemized.join_and} on #{the thing}." unless itemized.empty?
        end

        respond :look, available(Receptacle) do |actor, thing|
          actor.proceed
          actor.tell "You're currently in #{the thing}." if actor.parent == thing
          next unless actor.parent == thing

          itemized = thing.accessible.that_are_not(actor, proc(&:attached?)).that_are(proc(&:itemized?))
          next if itemized.empty?

          if actor.parent == thing
            actor.tell "You see #{itemized.join_and} here." unless itemized.empty?
          else
            actor.tell "You see #{itemized.join_and} in #{the thing}." unless itemized.empty?
          end
        end

        respond :look, parent(Supporter, proc(&:enterable?)) do |actor, supporter|
          actor.proceed
          actor.tell "You are currently on #{the supporter}."
        end

        respond :look, available(Thing, Openable) do |actor, thing|
          actor.tell thing.description if thing.has_description?
          actor.tell "#{The thing} is #{thing.open? ? 'open' : 'closed'}."
          next if thing.closed? || thing.children.empty?

          actor.tell "You see #{thing.children.join_and}."
        end

        respond :look, room do |actor, room|
          actor.tell "<strong>#{room.name.cap_first}</strong>"
          actor.tell room.description if room.described?
          itemize_room(actor)
        end

        interpret 'look around', 'look'
        interpret 'look here', 'look'
        interpret 'l', 'look'

        interpret 'look at :thing', 'look :thing'
        interpret 'look on :thing', 'look :thing'
        interpret 'look under :thing', 'look :thing'
        interpret 'look beneath :thing', 'look :thing'
        interpret 'look around :thing', 'look :thing'
        interpret 'l :thing', 'look :thing'
        interpret 'examine :thing', 'look :thing'
        interpret 'x :thing', 'look :thing'
        interpret 'inspect :thing', 'look :thing'
      end
    end
  end
end
