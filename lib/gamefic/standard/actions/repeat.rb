# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Repeat
        extend Gamefic::Scriptable

        after_command do |actor, command|
          next if command.verb == :repeat || command.input.nil?

          actor[:standard_repeatable_command] = command.input
        end

        meta :repeat do |actor|
          if actor[:standard_repeatable_command]
            actor.tell "Repeating <kbd>\"#{actor[:standard_repeatable_command]}\"</kbd>..."
            actor.perform actor[:standard_repeatable_command]
          else
            actor.tell "You don't have a previous command to repeat right now."
          end
        end

        interpret 'again', 'repeat'
      end
    end
  end
end
