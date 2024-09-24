# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Repeat
        extend Gamefic::Scriptable

        meta :repeat do |actor|
          if actor.last_input && !actor.last_input.empty?
            actor.tell "Repeating <kbd>\"#{actor.last_input}\"</kbd>..."
            actor.queue.push actor.last_input
          else
            actor.tell "You don't have a previous command to repeat right now."
          end
        end

        interpret 'again', 'repeat'
      end
    end
  end
end
