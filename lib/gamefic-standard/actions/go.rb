Gamefic.script do
  respond :go, Use.siblings(Portal) do |actor, portal|
    if actor.parent != actor.room
      actor.perform :leave
    end
    if actor.parent == actor.room
      if portal.destination.nil?
        actor.tell "That portal leads nowhere."
      else
        actor.parent = portal.destination
        if !portal.direction.nil?
          actor.tell "You go #{portal.direction}."
        end
        actor.perform :look
      end
    end
  end

  respond :go, Use.text do |actor, string|
    actor.tell "You don't see any exit \"#{string}\" from here."
  end

  respond :go do |actor|
    actor.tell "Where do you want to go?"
  end

  interpret "north", "go north"
  interpret "south", "go south"
  interpret "west", "go west"
  interpret "east", "go east"
  interpret "up", "go up"
  interpret "down", "go down"
  interpret "northwest", "go northwest"
  interpret "northeast", "go northeast"
  interpret "southwest", "go southwest"
  interpret "southeast", "go southeast"

  interpret "n", "go north"
  interpret "s", "go south"
  interpret "w", "go west"
  interpret "e", "go east"
  interpret "u", "go up"
  interpret "d", "go down"
  interpret "nw", "go northwest"
  interpret "ne", "go northeast"
  interpret "sw", "go southwest"
  interpret "se", "go southeast"

  interpret "go to :place", "go :place"
end
