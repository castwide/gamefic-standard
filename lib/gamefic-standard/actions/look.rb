module Gamefic
  module Standard
    script do
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
        actor.execute :_describe_room
      end

      meta :_describe_room do |actor|
        next unless actor.room

        actor.tell "<strong>#{actor.room.name.cap_first}</strong>"
        actor.tell actor.room.description if actor.room.has_description?
        actor.execute :_itemize_room
      end

      meta :_itemize_room do |actor|
        room = actor.room
        next unless room

        with_locales = []
        chars = room.children.that_are(Character).that_are(proc(&:itemized?)) - [actor]
        charsum = []
        chars.each do |char|
          if char.locale_description.nil?
            charsum.push char
          else
            with_locales.push char
          end
        end
        if charsum.length > 0
          actor.tell "#{charsum.join_and.cap_first} #{charsum.length == 1 ? 'is' : 'are'} here."
        end
        items = room.children.that_are(proc(&:itemized?)) - [actor] - room.children.that_are(Character) - room.children.that_are(Portal)
        itemsum = []
        items.each do |item|
          if item.locale_description.nil?
            itemsum.push item
          else
            with_locales.push item
          end
        end
        if itemsum.length > 0
          actor.tell "You see #{itemsum.join_and}."
        end
        with_locales.each { |entity|
          actor.tell entity.locale_description
        }
        if room.explicit_exits?
          portals = room.children.that_are(Portal).that_are(proc(&:itemized?))
          if portals.length > 0
            if portals.length == 1
              p = portals[0]
              actor.tell "There is an exit #{p.instruction}."
            else
              dirs = []
              portals.each do |p|
                dirs.push p.instruction
              end
              order = ['north', 'northeast', 'east', 'southeast', 'south', 'southwest', 'west', 'northwest', 'up', 'down']
              dirs.sort! { |a, b| (order.index(a.to_s) || order.length) <=> (order.index(b.to_s) || order.length) }
              actor.tell "There are exits #{dirs.join_and(', ')}."
            end
          end
        end
        actor.execute :_look_parent_from_room
      end

      meta :_look_parent_from_room do |actor|
        next unless actor.parent.is_a?(Supporter) || actor.parent.is_a?(Receptacle)

        preposition = actor.parent.is_a?(Supporter) ? 'on' : 'in'
        siblings = actor.parent.children.that_are_not(actor)
        if siblings.empty?
          actor.tell "You're #{preposition} #{the actor.parent}."
        else
          actor.tell "You're #{preposition} #{the actor.parent}, along with #{siblings.join_and}."
        end
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
