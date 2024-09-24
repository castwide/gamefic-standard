# frozen_string_literal: true

module Gamefic
  module Standard
    # Add a simple introduction that sets an appropriate name and synonyms for
    # the player character.
    #
    module Introduction
      extend Gamefic::Scriptable

      introduction do |actor|
        actor.name = 'you'
        actor.synonyms = 'self me yourself myself'
        actor.proper_named = true
      end
    end
  end
end
