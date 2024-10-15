# frozen_string_literal: true

module Gamefic
  module Standard
    # Methods for adding definite and indefinite articles to entity names.
    #
    module Articles
      extend Gamefic::Scriptable

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

      bind public_instance_methods
    end
  end
end
