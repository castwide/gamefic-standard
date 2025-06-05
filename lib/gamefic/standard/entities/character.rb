# frozen_string_literal: true

module Gamefic
  module Standard
    Character = Gamefic::Actor
    Character.set_default gender: :other

    class Character
      include ImplicitTaking

      def accessible
        children.select { |child| child.is_a?(Scenery) }
      end
    end
  end
end
