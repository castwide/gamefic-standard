# @gamefic.script standard/lockable

require 'gamefic-standard/openable'

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

  def has_lock_key?
    !@lock_key.nil?
  end
end

Gamefic.script do
  respond :lock, Use.available do |actor, thing|
    actor.tell "You can't lock #{the thing}."
  end

  respond :_toggle_lock, Use.available(Lockable, :has_lock_key?) do |actor, thing|
    verb = thing.locked? ? 'unlock' : 'lock'
    key = nil
    if thing.lock_key.parent == actor
      key = thing.lock_key
    end
    if key.nil?
      actor.tell "You don't have any way to #{verb} #{the thing}."
    else
      actor.tell "You #{verb} #{the thing} with #{the key}."
      thing.locked = !thing.locked?
    end
  end

  respond :lock, Use.available(Lockable, :has_lock_key?), Use.children do |actor, thing, key|
    if thing.lock_key == key
      actor.perform :_toggle_lock, thing
    else
      actor.tell "You can't unlock #{the thing} with #{the key}."
    end
  end

  respond :lock, Use.available(Lockable, :has_lock_key?), Use.available do |actor, thing, key|
    actor.perform :take, key if key.parent != actor
    actor.proceed if key.parent == actor
  end

  respond :unlock, Use.available do |actor, thing|
    actor.tell "You can't unlock #{the thing}."
  end

  respond :unlock, Use.available(Lockable, :has_lock_key?), Use.children do |actor, thing, key|
    if thing.lock_key == key
      actor.perform :_toggle_lock, thing
    else
      actor.tell "You can't unlock #{the thing} with #{the key}."
    end
  end

  respond :unlock, Use.available(Lockable, :has_lock_key?), Use.available do |actor, thing, key|
    actor.perform :take, key if key.parent != actor
    actor.proceed if key.parent == actor
  end

  respond :open, Use.available(Lockable) do |actor, thing|
    if thing.locked?
      actor.tell "#{The thing} is locked."
    else
      actor.proceed
    end
  end

  interpret "lock :container with :key", "lock :container :key"
  interpret "unlock :container with :key", "unlock :container :key"
  interpret "open :container with :key", "unlock :container :key"
end
