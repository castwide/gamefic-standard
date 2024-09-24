# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Inventory
        extend Gamefic::Scriptable

        respond :inventory do |actor|
          if actor.children.length > 0
            actor.tell "You are carrying #{actor.children.join_and}."
          else
            actor.tell "You aren't carrying anything."
          end
        end
        interpret 'i', 'inventory'
      end
    end
  end
end
