# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Wait
        extend Gamefic::Scriptable

        respond :wait do |actor|
          actor.tell 'Time passes.'
        end

        interpret 'z', 'wait'
      end
    end
  end
end
