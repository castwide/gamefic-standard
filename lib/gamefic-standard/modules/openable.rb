# A module for entities that are openable.
#
module Openable
  def open= bool
    @open = bool
  end

  def open?
    @open ||= false
  end

  def closed?
    !open?
  end

  def accessible?
    open?
  end
end
