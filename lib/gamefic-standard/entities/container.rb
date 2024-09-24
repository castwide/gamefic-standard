# frozen_string_literal: true

module Gamefic
  module Standard
    # An openable and lockable receptacle.
    #
    class Container < Receptacle
      include Openable
      include Lockable
    end
  end
end
