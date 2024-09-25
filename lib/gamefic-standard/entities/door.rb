# frozen_string_literal: true

# An openable portal.
#
class Door < Portal
  include Gamefic::Standard::Openable
  include Gamefic::Standard::Lockable

  def post_initialize
    update_reverse_open
  end

  def open=(bool)
    super
    update_reverse_open
  end

  def locked=(bool)
    super
    update_reverse_lock
  end

  def two_way_lock_key=(key)
    lock_key = key
    return if reverse.nil?

    reverse.lock_key = key
  end

  private

  def update_reverse_open
    rev = find_reverse
    return if rev.nil? || rev.open? == open?

    rev.open = open?
  end

  def update_reverse_lock
    rev = find_reverse
    return if rev.nil? || rev.locked? == locked?

    rev.locked = locked?
  end
end
