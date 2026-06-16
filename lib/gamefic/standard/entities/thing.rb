# frozen_string_literal: true

module Gamefic
  module Standard
    # @return [Class<Gamefic::Entity>]
    Thing = Gamefic::Entity

    class Gamefic::Entity
      include Standardized

      set_default itemized: true, portable: false
    end
  end
end
