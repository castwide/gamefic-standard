require 'gamefic-standard/openable'

# An openable portal.
#
class Door < Portal
  include Openable

  def post_initialize
    update_reverse_open
  end

  def open= bool
    super
    update_reverse_open
  end

  private

  def update_reverse_open
    rev = find_reverse
    return if rev.nil? || rev.open? == open?
    rev.open = open?
  end
end

Gamefic.script do
  respond :go, Use.available(Door) do |actor, door|
    actor.perform :open, door unless door.open?
    actor.proceed if door.open?
  end
end
