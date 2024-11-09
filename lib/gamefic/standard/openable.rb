# frozen_string_literal: true

module Gamefic
  module Standard
    # A module for entities that are openable.
    #
    module Openable
      def open
        self.open = true
      end

      def close
        self.open = false
      end

      def open=(bool)
        @open = bool
      end

      def open?
        @open ||= false
      end

      def closed?
        !open?
      end

      def accessible
        open? ? children : []
      end
    end
  end
end
