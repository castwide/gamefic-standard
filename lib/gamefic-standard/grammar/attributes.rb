# frozen_string_literal: true

module Gamefic
  module Standard
    module Grammar
      # A collection of attributes that enable grammar features for entities, such
      # as selecting their correct pronouns.
      #
      module Attributes
        # @see #gender
        attr_writer :gender

        # @see #plural?
        attr_writer :plural

        # The gender of the object. Supported values are :male, :female, :neutral,
        # and :other. Use :neutral for objects that don't have a gender (i.e.,
        # "it"). Use :other for people or characters that have an unspecified or
        # non-binary gender (i.e., "they").
        #
        # @return [Symbol]
        def gender
          @gender ||= :neutral
        end

        # True if the object should be referred to in the plural, e.g., "they"
        # instead of "it."
        # @return [Boolean]
        #
        def plural?
          @plural ||= false
        end

        # For now, the object's person is always assumed to be third
        # (he/she/it/they). A future version of this library might support first
        # (I/me) and second (you).
        def person
          3
        end
      end
    end
  end
end
