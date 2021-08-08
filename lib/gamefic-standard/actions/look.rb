Gamefic.script do
  respond :look, Use.text(/^here$/i) do |actor, _|
    actor.perform :look, actor.room
  end

  respond :look, Use.itself do |actor, _|
    actor.tell actor.description
    actor.perform :inventory
  end

  respond :look, Use.available(Thing) do |actor, thing|
    actor.tell thing.description
    thing.children.that_are(:attached?).that_are(:itemized?).each do |item|
      actor.tell "#{An item} is attached to #{the thing}."
    end
  end

  respond :look, Use.available(Supporter) do |actor, thing|
    itemized = thing.children.that_are_not(:attached?).that_are(:itemized?)
    # If the supporter does not have a description but it does contain
    # itemized things, avoid saying there's nothing special about it.
    actor.proceed if thing.has_description? || itemized.empty?
    actor.tell "You see #{itemized.join_and} on #{the thing}." unless itemized.empty?
  end

  respond :look, Use.available(Receptacle) do |actor, thing|
    actor.proceed
    if thing.accessible?
      itemized = thing.children.that_are_not(:attached?).that_are(:itemized?)
      actor.tell "You see #{itemized.join_and} in #{the thing}." unless itemized.empty?
    end
  end

  respond :look, Use.parent(Supporter, :enterable?) do |actor, supporter|
    actor.proceed
    actor.tell "You are currently on #{the supporter}."
  end

  respond :look, Use.available(Thing, Openable) do |actor, thing|
    actor.proceed
    actor.tell "#{The thing} is #{thing.open? ? 'open' : 'closed'}."
  end

  respond :look, Use.room do |actor, room|
    actor.tell "<strong>#{room.name.cap_first}</strong>"
    actor.tell room.description if room.has_description?
    actor.execute :_itemize_room
  end

  meta :_itemize_room do |actor|
    room = actor.room
    next if room.nil?
    with_locales = []
    chars = room.children.that_are(Character).that_are(:itemized?) - [actor]
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
    items = room.children.that_are(:itemized?) - [actor] - room.children.that_are(Character) - room.children.that_are(Portal)
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
      portals = room.children.that_are(Portal).that_are(:itemized?)
      if portals.length > 0
        if portals.length == 1
          p = portals[0]
          actor.tell "There is an exit #{p.instruction}."
        else
          dirs = []
          portals.each do |p|
            dirs.push p.instruction
          end
          actor.tell "There are exits #{dirs.join_and(', ')}."
        end
      end
    end
    if actor.parent.is_a?(Supporter)
      actor.tell "You are on #{the actor.parent}."
      actor.parent.children.that_are_not(actor).each { |s|
        actor.tell "#{A s} is on #{the actor.parent}."
      }
    end
  end

  interpret 'look around', 'look here'
  interpret 'look', 'look here'
  interpret 'l', 'look here'

  interpret 'look at :thing', 'look :thing'
  interpret 'l :thing', 'look :thing'
  interpret 'examine :thing', 'look :thing'
  interpret 'x :thing', 'look :thing'
end
