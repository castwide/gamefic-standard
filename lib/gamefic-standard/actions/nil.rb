# frozen_string_literal: true

module Gamefic
  module Standard
    module Actions
      module Nil
        extend Gamefic::Scriptable

        meta nil, plaintext do |actor, string|
          next if string.strip.empty?

          words = string.keywords
          if actor.can?(words[0])
            if words.length > 1
              possible = [actor] + available.span(actor)
              result = Scanner.scan(possible, words[1..-1].join(' '))
              if result.matched.empty?
                actor.tell %(I recognize "#{words[0]}" as a verb but don't know what you mean by "#{words[1..-1].join(' ')}.")
              elsif result.remainder != ''
                actor.tell %(I recognize "#{string.sub(/#{result.remainder}$/,
                                                       '').strip}" as a command but was confused by "#{result.remainder}.")
              elsif result.matched.one?
                actor.tell %(I recognize "#{words[0]}" and "#{result.matched.first.name}" but could not understand them together.)
              else
                actor.tell %(I recognize "#{words[0]}" but I'm not sure if "#{words[1..-1].join(' ')}" means #{result.matched.map(&:definitely).join_or}.)
              end
            else
              actor.tell %(I recognize "#{words[0]}" as a verb but could not understand it in this context.)
            end
          else
            actor.tell %(I don't recognize "#{words[0]}" as a verb.)
          end
        end
      end
    end
  end
end
