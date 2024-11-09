# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Mount
        extend Gamefic::Scriptable

        respond :mount, siblings do |actor, thing|
          actor.tell "#{The thing} can't accommodate you."
        end

        respond :mount, siblings(Supporter, proc(&:enterable?)) do |actor, supporter|
          actor.put supporter, :on
          actor.tell "You get on #{the supporter}."
        end

        respond :mount, parent(Supporter) do |actor, supporter|
          actor.tell "You're already on #{the supporter}."
        end

        interpret 'get on :thing', 'mount :thing'
        interpret 'sit on :thing', 'mount :thing'
        interpret 'lie on :thing', 'mount :thing'
        interpret 'stand on :thing', 'mount :thing'
      end
    end
  end
end
