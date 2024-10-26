# frozen_string_literal: true

module Gamefic
  module Standard
    module Enterable
      attr_writer :enterable

      def enterable?
        @enterable ||= false
      end
    end
  end
end
