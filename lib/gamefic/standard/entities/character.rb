# frozen_string_literal: true

module Gamefic
  module Standard
    # @return [Class<Gamefic::Actor>]
    Character = Gamefic::Actor

    class Gamefic::Actor
      include Standardized
      include ImplicitTaking

      set_default gender: :other

      def accessible
        children.select { |child| child.is_a?(Scenery) }
      end
    end
  end
end
