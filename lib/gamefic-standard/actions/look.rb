# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Look
        extend Gamefic::Scriptable

        include Clips

        respond :look do |actor|
          actor.execute :look, actor.room
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
          next unless actor.parent == thing || thing.accessible?

          itemized = thing.children.that_are_not(actor, proc(&:attached?)).that_are(proc(&:itemized?))
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
          ItemizeRoom.run(actor)
          ItemizeParent.run(actor) if actor.parent != room
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
