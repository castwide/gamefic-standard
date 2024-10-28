# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Give
        extend Gamefic::Scriptable
        include Gamefic::What

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
          actor.cue AskForWhat, template: "give #{the thing} to __what__"
        end

        respond :give, Character do |actor, character|
          actor.tell "What do you want to give to #{the character}?"
          actor.cue AskForWhat, template: "give __what__ to #{the character}"
        end

        interpret 'give :gift to :character', 'give :character :gift'
      end
    end
  end
end
