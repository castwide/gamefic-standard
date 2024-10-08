# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Go
        extend Gamefic::Scriptable

        respond :go, siblings(Portal) do |actor, portal|
          if portal.destination.nil?
            actor.tell 'That portal leads nowhere.'
          else
            actor.parent = portal.destination
            actor.tell "You go #{portal.direction}." unless portal.direction.nil?
            actor.execute :look
          end
        end

        respond :go, plaintext do |actor, text|
          if actor.parent == actor.room
            actor.tell "I don't see any way to go \"#{text}\" from here."
          else
            actor.execute :leave
            if actor.parent == actor.room
              actor.perform "go #{text}"
            else
              actor.proceed
            end
          end
        end

        respond :go, available(Door) do |actor, door|
          actor.execute :open, door unless door.open?
          actor.proceed if door.open?
        end

        interpret 'north', 'go north'
        interpret 'south', 'go south'
        interpret 'west', 'go west'
        interpret 'east', 'go east'
        interpret 'up', 'go up'
        interpret 'down', 'go down'
        interpret 'northwest', 'go northwest'
        interpret 'northeast', 'go northeast'
        interpret 'southwest', 'go southwest'
        interpret 'southeast', 'go southeast'

        interpret 'n', 'go north'
        interpret 's', 'go south'
        interpret 'w', 'go west'
        interpret 'e', 'go east'
        interpret 'u', 'go up'
        interpret 'd', 'go down'
        interpret 'nw', 'go northwest'
        interpret 'ne', 'go northeast'
        interpret 'sw', 'go southwest'
        interpret 'se', 'go southeast'

        interpret 'go to :place', 'go :place'
      end
    end
  end
end
