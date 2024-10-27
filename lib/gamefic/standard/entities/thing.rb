# frozen_string_literal: true

module Gamefic
  module Standard
    Thing = Gamefic::Entity
    Thing.set_default itemized: true, portable: false
    Thing.include Gamefic::Standard::Standardized
  end
end
