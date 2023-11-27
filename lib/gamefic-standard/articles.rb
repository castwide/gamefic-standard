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
  def a_(entity)
    entity.indefinitely.cap_first
  end
  alias an_ a_
  alias A a_
  alias An a_

  # Get a capitalized name for the entity with a definite article (unless
  # the entity has a proper name).
  #
  # @param entity [Gamefic::Entity]
  # @return [String]
  def the_(entity)
    entity.definitely.cap_first
  end
  alias The the_
end

Gamefic::Narrative::ScriptMethods.include Articles
# @todo For some reason, the following delegate and includes are necessary in Opal
if RUBY_ENGINE == 'opal'
  Gamefic::Narrative.delegate Gamefic::Narrative::ScriptMethods
  Gamefic::Plot::ScriptMethods.include Articles
  Gamefic::Subplot::ScriptMethods.include Articles
end
