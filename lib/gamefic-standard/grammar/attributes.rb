module Grammar
  # A collection of attributes that enable grammar features for entities, such
  # as selecting their correct pronouns.
  #
  module Attributes
    # @see #gender
    attr_writer :gender

    # The gender of the object. Supported values are :male, :female, :neutral,
    # and :other. Use :neutral for objects that don't have a gender (i.e.,
    # "it"). Use :other for people or characters that have an unspecified or
    # non-binary gender (i.e., "they").
    # @return [Symbol]
    def gender
      @gender ||= :neutral
    end

    # @todo Make it more expressive
    def plural?
      false
    end

    # @todo Make it more expressive
    def person
      3
    end
  end
end
