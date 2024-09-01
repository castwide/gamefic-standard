module Gamefic
  module Standard
    script do
      respond :leave, parent do |actor, thing|
        actor.tell "There's no way out of #{the thing}."
      end

      respond :leave, parent(Enterable, proc(&:enterable?)) do |actor, thing|
        actor.tell "You leave #{the thing}."
        actor.parent = thing.parent
      end

      respond :leave, parent(Supporter, proc(&:enterable?)) do |actor, thing|
        actor.tell "You get off #{the thing}."
        actor.parent = thing.parent
      end

      respond :leave, room do |actor, room|
        portals = room.children.that_are(Portal)
        if portals.length == 0
          actor.tell "You don't see any obvious exits."
        elsif portals.length == 1
          actor.execute :go, portals[0]
        else
          actor.tell "I don't know which way you want to go: #{portals.map(&:definitely).join_or}."
        end
      end

      respond :leave do |actor|
        if actor.parent
          actor.execute :leave, actor.parent
        else
          actor.tell "You don't see any obvious exits."
        end
      end

      respond :leave, parent(Container, proc(&:enterable?), proc(&:closed?)) do |actor, container|
        actor.execute :open, container
        actor.proceed if container.open?
      end

      interpret "exit", "leave"
      interpret "exit :supporter", "leave :supporter"
      interpret "get on :supporter", "enter :supporter"
      interpret "get off :supporter", "leave :supporter"
      interpret "get out :container", "leave :container"
      interpret "get out of :container", "leave :container"
    end
  end
end
