# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Quit
        extend Gamefic::Scriptable

        ConfirmQuit = yes_or_no :confirm_quit do |scene|
          scene.on_start do |actor|
            actor.tell 'Are you sure you want to quit?'
          end
          scene.on_finish do |actor, props|
            # @todo default_conclusion doesn't work here
            actor.cue Gamefic::Scene::Conclusion if props.yes?
          end
        end

        meta :quit do |actor|
          actor.cue :confirm_quit
        end
      end
    end
  end
end
