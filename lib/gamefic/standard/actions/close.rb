# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Close
        extend Gamefic::Scriptable

        respond :close, available do |actor, thing|
          actor.tell "You can't close #{the thing}."
        end

        respond :close, available(Openable) do |actor, thing|
          if thing.open?
            actor.tell "You close #{the thing}."
            thing.open = false
          else
            actor.tell "#{The thing} is already closed."
          end
        end
      end
    end
  end
end
