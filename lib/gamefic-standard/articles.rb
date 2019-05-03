module Articles

  # Get a name for the entity with an indefinite article (unless the entity
  # has a proper name).
  #
  # @param entity [Gamefic::Entity]
  # @return [String]
  def a(entity)
    entity.indefinitely
  end
  alias an a

  # Get a name for the entity with a definite article (unless the entity has
  # a proper name).
  #
  # @param entity [Gamefic::Entity]
  # @return [String]
  def the(entity)
    entity.definitely
  end

  # Get a capitalized name for the entity with an indefinite article (unless
  # the entity has a proper name).
  #
  # @param entity [Gamefic::Entity]
  # @return [String]
  def A(entity)
    entity.indefinitely.cap_first
  end
  alias An A

  # Get a capitalized name for the entity with a definite article (unless
  # the entity has a proper name).
  #
  # @param entity [Gamefic::Entity]
  # @return [String]
  def The(entity)
    entity.definitely.cap_first
  end
end

class Gamefic::Plot
  include Articles
end

class Gamefic::Subplot
  include Articles
end
