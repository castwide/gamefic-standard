# A module for entities that are both openable and lockable.
#
module Lockable
  include Openable

  attr_accessor :lock_key

  def locked=(bool)
    @locked = bool
    if @locked == true
      self.open = false
    end
  end

  def open=(bool)
    @open = bool
    @locked = false if @open == true
  end

  def locked?
    @locked ||= false
  end

  def unlocked?
    !locked?
  end

  def lock_key?
    !@lock_key.nil?
  end
  alias has_lock_key? lock_key?
end
