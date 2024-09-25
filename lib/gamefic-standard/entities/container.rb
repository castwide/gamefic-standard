# frozen_string_literal: true

# An openable and lockable receptacle.
#
class Container < Receptacle
  include Gamefic::Standard::Openable
  include Gamefic::Standard::Lockable
end
