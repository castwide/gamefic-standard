# frozen_string_literal: true

module Gamefic
  module Standard
    module ImplicitTaking
      def have_or_take(entity)
        execute(:take, entity) unless possessions.include?(entity)

        possessions.include?(entity)
      end
      alias has_or_takes have_or_take

      private

      def possessions(from = children)
        return [] if from.empty?

        from + possessions(from.flat_map(&:accessible))
      end
    end
  end
end
