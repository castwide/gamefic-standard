# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Attack
        extend Gamefic::Scriptable

        respond :attack do |actor|
          actor.tell 'Violence is not the answer here.'
        end

        respond :attack, Thing do |actor, _thing|
          actor.execute :attack
        end

        interpret 'fight', 'attack'
        interpret 'battle', 'attack'
        interpret 'kill', 'attack'
        interpret 'punch', 'attack'
        interpret 'kick', 'attack'
        interpret 'hit', 'attack'
        interpret 'fight :thing', 'attack :thing'
        interpret 'battle :thing', 'attack :thing'
        interpret 'kill :thing', 'attack :thing'
        interpret 'punch :thing', 'attack :thing'
        interpret 'kick :thing', 'attack :thing'
        interpret 'hit :thing', 'attack :thing'
      end
    end
  end
end
