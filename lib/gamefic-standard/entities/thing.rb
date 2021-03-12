class Thing < Gamefic::Entity
  include Grammar::Attributes

  # @return [Boolean]
  attr_writer :itemized

  # @return [Boolean]
  attr_writer :portable

  # An optional description to use when itemizing entities in room
  # descriptions. The locale_description will be used instead of adding
  # the entity's name to a list.
  #
  # @return [String, nil]
  attr_accessor :locale_description

  set_default itemized: true
  set_default portable: false

  # Itemized entities are automatically listed in room descriptions.
  #
  # @return [Boolean]
  def itemized?
    @itemized
  end

  # Portable entities can be taken with TAKE actions.
  #
  # @return [Boolean]
  def portable?
    @portable
  end

  # @return [Boolean]
  def attached?
    @attached ||= false
  end

  # @param bool [Boolean]
  def attached= bool
    @attached = if parent.nil?
      # @todo Log attachment failure
      false
    else
      bool
    end
  end

  def parent= new_parent
    self.attached = false unless new_parent == parent
    super
  end

  # The entity's parent room (i.e., the closest ascendant that is a Room).
  #
  # @return [Room]
  def room
    p = parent
    until p.is_a?(Room) or p.nil?
      p = p.parent
    end
    p
  end
end
