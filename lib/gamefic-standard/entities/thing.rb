class Thing < Gamefic::Entity
  include Grammar::Attributes

  attr_writer :itemized

  attr_writer :portable

  # An optional description to use when itemizing entities in room
  # descriptions. The locale_description will be used instead of adding
  # the entity's name to a list.
  #
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

  # @param [Boolean]
  def attached= bool
    bool = false if parent.nil?
    @attached = bool
  end

  def parent= p
    self.attached = false unless p == parent
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
