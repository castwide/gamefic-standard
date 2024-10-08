# frozen_string_literal: true

module Gamefic
  module Standard
    module Clips
      class ConfirmQuit < Gamefic::Clip
        class YesOrNo < Gamefic::Scene::YesOrNo
          on_finish do |actor, props|
            actor.cue Gamefic::Scene::Conclusion if props.yes?
          end
        end

        def run
          actor.tell 'Are you sure you want to quit?'
          actor.cue YesOrNo
        end
      end
    end
  end
end
