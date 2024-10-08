# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Quit
        extend Gamefic::Scriptable

        meta :quit do |actor|
          actor.run Clips::ConfirmQuit
        end
      end
    end
  end
end
