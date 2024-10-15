# frozen_string_literal: true

module Gamefic
  module Standard
    module Clips
      class ItemizeParent < Gamefic::Clip
        include Gamefic::Standard
        # @todo Opal needs to include Articles despite including Standard
        include Gamefic::Standard::Articles

        def run
          return unless (parent = actor.parent)
          return ItemizeRoom.run(actor) if actor.parent == actor.room

          preposition = parent.is_a?(Supporter) ? 'on' : 'in'
          siblings = parent.children.that_are_not(actor)
          if siblings.empty?
            actor.tell "You're #{preposition} #{the parent}."
          else
            actor.tell "You're #{preposition} #{the parent}, along with #{siblings.join_and}."
          end
        end
      end
    end
  end
end
