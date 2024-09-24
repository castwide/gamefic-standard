# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Move
        extend Gamefic::Scriptable

        respond :move, Thing do |actor, thing|
          if thing.portable?
            actor.tell 'Maybe you want to <em>take</em> it?'
          else
            actor.tell "You can't move #{the thing}."
          end
        end

        respond :move, children(Thing) do |actor, thing|
          actor.tell "You're already carrying #{the thing}."
        end

        interpret 'push :thing', 'move :thing'
        interpret 'pull :thing', 'move :thing'
        interpret 'drag :thing', 'move :thing'
        interpret 'lift :thing', 'move :thing'
      end
    end
  end
end
