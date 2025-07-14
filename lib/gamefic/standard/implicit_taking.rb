# frozen_string_literal: true

module Gamefic
  module Standard
    # A mixin that provides a #have_or_take method to automate possession.
    # Authors can use it to ensure that an actor is holding an entity as a
    # prerequisite to doing something with it.
    #
    module ImplicitTaking
      # True if the actor is already holding the entity or successfully takes
      # possession of it.
      #
      # @example Actor needs to be holding the item to use it
      #   respond :use, Item do |actor, item|
      #     if actor.have_or_take(item)
      #       actor.tell "You're using #{the item}."
      #     else
      #       actor.tell "You can't use #{the item}."
      #     end
      #   end
      #
      # @param entity [Gamefic::Entity]
      # @return [Boolean]
      def have_or_take(entity)
        execute(:take, entity) unless possessions.include?(entity)

        possessions.include?(entity)
      end
      alias has_or_takes have_or_take

      private

      # @param from [Array<Gamefic::Entity>]
      # @return [Array<Gamefic::Entity>]
      def possessions(from = children)
        return [] if from.empty?

        from + possessions(from.flat_map(&:accessible))
      end
    end
  end
end
