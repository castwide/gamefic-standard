# frozen_string_literal: true

# An openable and lockable portal.
#
class Door < Portal
  include Gamefic::Standard::Openable
  include Gamefic::Standard::Lockable

  def post_initialize
    update_reverse_open
    update_reverse_lock
  end

  def open=(bool)
    super
    reverse&.lock_key = lock_key
    update_reverse_open
    update_reverse_lock
  end

  def locked=(bool)
    super
    update_reverse_lock
  end

  def two_way_lock_key=(key)
    self.lock_key = key
    reverse&.lock_key = key
  end

  private

  def update_reverse_open
    rev = find_reverse
    rev&.open = open? unless rev&.open? == open?
  end

  def update_reverse_lock
    rev = find_reverse
    rev&.locked = locked? unless rev&.locked? == locked?
  end
end
