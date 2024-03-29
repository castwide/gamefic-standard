# frozen_string_literal: true

# An openable and lockable receptacle.
#
class Container < Receptacle
  include Openable
  include Lockable
end
