# frozen_string_literal: true

module Gamefic
  module Standard
    Thing = Gamefic::Entity
    # @!parse
    #   class Thing < Gamefic::Entity; end

    Thing.set_default itemized: true, portable: false
    Thing.include Gamefic::Standard::Standardized
  end
end
