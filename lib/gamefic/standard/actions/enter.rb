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

        interpret 'get in :thing', 'enter :thing'
        interpret 'get inside :thing', 'enter :thing'
        interpret 'sit in :thing', 'enter :thing'
        interpret 'lie in :thing', 'enter :thing'
        interpret 'stand in :thing', 'enter :thing'
      end
    end
  end
end
