# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Take
        extend Gamefic::Scriptable

        respond :take, available do |actor, thing|
          if thing.parent == actor
            actor.tell "You're already carrying #{the thing}."
          elsif thing.portable?
            if actor.parent != thing.parent
              actor.tell "You take #{the thing} from #{the thing.parent}."
            else
              actor.tell "You take #{the thing}."
            end
            thing.parent = actor
          else
            actor.tell "You can't take #{the thing}."
          end
        end

        respond :take, available(proc(&:attached?)) do |actor, thing|
          actor.tell "#{The thing} is attached to #{the thing.parent}."
        end

        respond :take, available(Rubble) do |actor, rubble|
          actor.tell "You don't have any use for #{the rubble}."
        end

        respond :take, plaintext(/^(all|everything)$/) do |actor, _all|
          items = Gamefic::Scope::Family.matches(actor)
                                        .select(&:portable?)
                                        .reject { |item| actor.flatten.include?(item) }
          if items.empty?
            actor.tell "You don't see anything you can carry."
          else
            items.each { |item| actor.execute :take, item }
          end
        end

        interpret 'get :thing', 'take :thing'
        interpret 'pick up :thing', 'take :thing'
        interpret 'pick :thing up', 'take :thing'
        interpret 'carry :thing', 'take :thing'
      end
    end
  end
end
