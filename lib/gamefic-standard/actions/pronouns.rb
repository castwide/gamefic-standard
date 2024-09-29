# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Pronouns
        extend Gamefic::Scriptable

        introduction do |actor|
          actor[:standard_pronoun_targets] = []
        end

        after_action do |action|
          next unless action.verb

          action.actor[:standard_pronoun_targets].replace action.arguments.that_are(Thing)
        end

        meta nil, plaintext do |actor, string|
          keywords = string.keywords
          list = actor.epic.synonyms
          next actor.proceed unless list.include?(keywords.first&.to_sym)

          xlation = keywords[1..].map do |word|
            next word unless %w[him her it them].include?(word)

            actor[:standard_pronoun_targets].find { |obj| obj.objective == word }
          end
          next actor.proceed if xlation.any?(&:nil?) || xlation.that_are(Thing).empty?

          actor.perform "#{keywords[0].to_sym} #{xlation.join(' ')}"
        end
      end
    end
  end
end
