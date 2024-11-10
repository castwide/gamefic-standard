# frozen_string_literal: true

module Gamefic
  module Standard
    # A module for entities that are both openable and lockable.
    #
    module Lockable
      include Openable

      attr_accessor :lock_key

      def lock
        self.locked = true
      end

      def unlock
        self.locked = false
      end

      def locked=(bool)
        @locked = bool
        @open = false if @locked
      end

      def open=(bool)
        @open = bool
        @locked = false if @open
      end

      def locked?
        @locked ||= false
      end

      def unlocked?
        !locked?
      end

      def lock_key?
        !@lock_key.nil?
      end
      alias has_lock_key? lock_key?
    end
  end
end
