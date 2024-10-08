# frozen_string_literal: true

module Gamefic
  module Standard
    # Common features of standard entities.
    #
    module Standardized
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
      def attached=(bool)
        @attached = if parent.nil?
                      # @todo Log attachment failure
                      false
                    else
                      bool
                    end
      end

      def parent=(new_parent)
        self.attached = false unless new_parent == parent
        super
      end

      # The entity's parent room (i.e., the closest ascendant that is a Room).
      #
      # @return [Room]
      def room
        ascendant = parent
        ascendant = ascendant.parent until ascendant.is_a?(Room) || ascendant.nil?
        ascendant
      end
    end
  end
end
