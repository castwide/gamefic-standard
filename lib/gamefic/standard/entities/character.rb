# frozen_string_literal: true

module Gamefic
  module Standard
    Character = Gamefic::Actor
    # @!parse
    #   class Character < Gamefic::Actor; end

    class Character
      include ImplicitTaking

      set_default gender: :other

      def accessible
        children.select { |child| child.is_a?(Scenery) }
      end
    end
  end
end
