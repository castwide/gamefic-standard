# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Quit
        extend Gamefic::Scriptable

        ConfirmQuit = yes_or_no do
          on_start do |actor|
            actor.tell 'Are you sure you want to quit?'
          end
          on_finish do |actor, props|
            actor.cue default_conclusion if props.yes?
          end
        end

        meta :quit do |actor|
          actor.cue ConfirmQuit
        end
      end
    end
  end
end
