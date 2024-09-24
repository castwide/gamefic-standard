# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Quit
        extend Gamefic::Scriptable

        yes_or_no :standard_confirm_quit do |actor, props|
          actor.cue :default_conclusion if props.yes?
        end

        meta :quit do |actor|
          actor.tell 'Are you sure you want to quit?'
          actor.cue :standard_confirm_quit
        end
      end
    end
  end
end
