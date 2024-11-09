# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Place
        extend Gamefic::Scriptable

        respond :place, children, available do |actor, thing, supporter|
          actor.tell "You can't put #{the thing} on #{the supporter}."
        end

        respond :place, available, available(Supporter) do |actor, thing, supporter|
          actor.execute :take, thing unless thing.parent == actor
          next unless thing.parent == actor

          thing.put supporter, :on
          actor.tell "You put #{the thing} on #{the supporter}."
        end

        respond :place, children, available(Supporter) do |actor, thing, supporter|
          thing.put supporter, :on
          actor.tell "You put #{the thing} on #{the supporter}."
        end

        respond :place, children, room do |actor, thing|
          actor.execute :drop, thing
        end

        interpret 'put :thing on :supporter', 'place :thing :supporter'
        interpret 'put :thing down on :supporter', 'place :thing :supporter'
        interpret 'set :thing on :supporter', 'place :thing :supporter'
        interpret 'set :thing down on :supporter', 'place :thing :supporter'
        interpret 'drop :thing on :supporter', 'place :thing :supporter'
        interpret 'place :thing on :supporter', 'place :thing :supporter'
      end
    end
  end
end
