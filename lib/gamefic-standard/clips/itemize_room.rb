# frozen_string_literal: true

module Gamefic
  module Standard
    module Clips
      class ItemizeRoom < Gamefic::Clip
        include Gamefic::Standard

        def run
          return unless (room = actor.room)

          siblings = room.children.select(&:itemized?).that_are_not(actor)

          siblings.that_are(Character)
                  .reject(&:locale_description)
                  .tap do |list|
                    list.empty? or actor.tell "#{list.join_and.cap_first} #{list.one? ? 'is' : 'are'} here."
                  end

          siblings.that_are_not(Character, Portal)
                  .reject(&:locale_description)
                  .tap do |list|
                    list.empty? or actor.tell "You see #{list.join_and}."
                  end

          siblings.select(&:locale_description)
                  .each { |thing| actor.tell thing.locale_description }

          return unless room.explicit_exits?

          earlier = siblings.select(&:locale_description).that_are(Portal).any?
          siblings.that_are(Portal)
                  .reject(&:locale_description)
                  .tap do |portals|
                    if portals.one?
                      actor.tell "There is#{earlier ? ' also ' : ' '}an exit #{portals.first.instruction}."
                    else
                      order = %w[north northeast east southeast south southwest west northwest up down]
                      dirs = portals.map(&:instruction)
                                    .map(&:to_s)
                                    .sort { |a, b| order.index(a) || 0 <=> order.index(b) || 1 }
                      actor.tell "There are#{earlier ? ' also ' : ' '}exits #{dirs.join_and(', ')}."
                    end
                  end
        end
      end
    end
  end
end
