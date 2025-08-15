# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Enter
        extend Gamefic::Scriptable

        respond :enter, siblings do |actor, thing|
          actor.tell "#{The thing} can't accommodate you."
        end

        respond :enter, siblings(Enterable, proc(&:enterable?)) do |actor, supporter|
          actor.parent = supporter
          actor.tell "You get in #{the supporter}."
        end

        respond :enter, parent do |actor, container|
          actor.tell "You're already in #{the container}."
        end

        respond :enter, siblings(Container, proc(&:enterable?), proc(&:closed?)) do |actor, container|
          actor.tell "#{The container} is closed."
        end

        interpret 'get in|inside :thing', 'enter :thing'
        interpret 'sit|lie|stand in|inside :thing', 'enter :thing'
      end
    end
  end
end
