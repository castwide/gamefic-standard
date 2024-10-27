# frozen_string_literal: true

module Gamefic
  module Standard
    # An openable and lockable receptacle.
    #
    class Container < Receptacle
      include Gamefic::Standard::Openable
      include Gamefic::Standard::Lockable
    end
  end
end
