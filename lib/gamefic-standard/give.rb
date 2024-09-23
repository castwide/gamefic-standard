module Gamefic
  module Standard
    module Give
      extend Gamefic::Scriptable

      script do
        respond :give, available, children do |actor, _character, _gift|
          actor.tell 'Nothing happens.'
        end

        respond :give, available(Character), available do |actor, character, gift|
          actor.tell "#{The character} has no use for #{the gift}."
        end

        respond :give, available(Character), available do |actor, _character, gift|
          actor.execute :take, gift if gift.parent != actor

          actor.proceed if gift.parent == actor
        end

        respond :give, Thing do |actor, thing|
          actor.tell "Who do you want to give #{the thing} to?"
          actor.ask_for_what "give #{thing} to __what__"
        end

        respond :give, Character do |actor, character|
          actor.tell "What do you want to give to #{the character}?"
          actor.ask_for_what "give __what__ to #{character}"
        end

        interpret 'give :gift to :character', 'give :character :gift'
      end
    end
  end
end
