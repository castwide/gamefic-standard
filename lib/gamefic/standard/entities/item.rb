# frozen_string_literal: true

module Gamefic
  module Standard
    # An entity that is portable by default.
    #
    class Item < Thing
      set_default portable: true
    end
  end
end
