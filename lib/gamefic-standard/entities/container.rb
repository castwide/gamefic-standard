require 'gamefic-standard/openable'
require 'gamefic-standard/lockable'

# An openable and lockable receptacle.
#
class Container < Receptacle
  include Openable
  include Lockable
end
