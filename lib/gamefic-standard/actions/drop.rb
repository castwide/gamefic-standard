# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Drop
        extend Gamefic::Scriptable

        respond :drop, available do |actor, thing|
          actor.tell "You're not carrying #{the thing}."
        end

        respond :drop, children do |actor, thing|
          actor.execute :take, thing
          next unless thing.parent == actor

          thing.parent = actor.parent
          actor.tell "You drop #{the thing}."
        end

        respond :drop, children do |actor, thing|
          thing.parent = actor.parent
          actor.tell "You drop #{the thing}."
        end

        interpret 'put down :thing', 'drop :thing'
        interpret 'put :thing down', 'drop :thing'
      end
    end
  end
end
