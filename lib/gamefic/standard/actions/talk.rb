# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Talk
        extend Gamefic::Scriptable

        respond :talk do |actor|
          actor.tell 'You talk to yourself.'
        end

        respond :talk, myself do |actor, _yourself|
          actor.execute :talk
        end

        respond :talk, available do |actor, _thing|
          actor.tell 'Nothing happens.'
        end

        respond :talk, Character do |actor, character|
          actor.tell "#{The character} has nothing to say."
        end

        respond :talk, available, plaintext do |actor, thing, _text|
          actor.execute :talk, thing
        end

        respond :talk, Character, plaintext do |actor, character, _text|
          actor.execute :talk, character
        end

        interpret 'talk to :character', 'talk :character'
        interpret 'talk to :character about :subject', 'talk :character :subject'
        interpret 'ask :character :subject', 'talk :character :subject'
        interpret 'ask :character about :subject', 'talk :character :subject'
        interpret 'tell :character :subject', 'talk :character :subject'
        interpret 'tell :character about :subject', 'talk :character :subject'
        interpret 'ask :character for :subject', 'talk :character :subject'
        interpret 'speak :character', 'talk :character'
        interpret 'speak to :character', 'talk :character'
        interpret 'speak :character :subject', 'talk :character :subject'
        interpret 'speak :character about :subject', 'talk :character :subject'
        interpret 'speak to :character about :subject', 'talk :character :subject'
        interpret 'speak to :character :subject', 'talk :character :subject'
        interpret 'discuss :subject :character', 'talk :character :subject'
        interpret 'discuss :subject with :character', 'talk :character :subject'
      end
    end
  end
end
