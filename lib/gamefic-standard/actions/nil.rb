module Gamefic
  module Standard
    module Nil
      extend Gamefic::Scriptable

      meta nil, plaintext do |actor, string|
        next if string.strip.empty?

        words = string.keywords
        list = actor.epic.synonyms
        if list.include?(words[0]&.to_sym)
          if words.length > 1
            result = myself.query(actor, words[1..-1].join(' '))
            found = [result.match].compact
            avail = available(ambiguous: true)
            result = avail.query(actor, result.remainder)
            until result.match.nil?
              found.concat result.match
              result = avail.query(actor, result.remainder)
            end
            if found.empty?
              verbs = actor.epic
                           .syntaxes
                           .select { |syn| syn.synonym == words[0].to_sym }
                           .map(&:verb)
              resps = actor.epic.responses_for(*verbs)
              if resps.any? { |resp| !resp.queries.empty? }
                actor.tell %(I recognize "#{words[0]}" as a verb but don't know what you mean by "#{words[1..-1].join(' ')}.")
              else
                actor.tell %[I recognize "#{words[0]}" but not with the rest of your sentence. (Maybe it's a one-word command?)]
              end
            elsif result.remainder != ''
              actor.tell %(I recognize "#{words[0]}" as a verb but was confused by "#{result.remainder}.")
            elsif found.one?
              verbs = actor.epic
                           .syntaxes
                           .select { |syn| syn.synonym == words[0].to_sym }
                           .map(&:verb)
              resps = actor.epic.responses_for(*verbs)
              if resps.any? { |resp| !resp.queries.empty? }
                actor.tell %(I recognize "#{words[0]}" and "#{found.first.name}" but could not understand them together.)
              else
                actor.tell %[I recognize "#{words[0]}" and "#{found.first.name}" but could not understand them together. (Maybe "#{words[0]}" is a one-word command?)]
              end
            else
              verbs = actor.epic
                           .syntaxes
                           .select { |syn| syn.synonym == words[0].to_sym }
                           .map(&:verb)
              resps = actor.epic.responses_for(*verbs)
              if resps.any? { |resp| !resp.queries.empty? }
                actor.tell %(I recognize "#{words[0]}" but I'm not sure if "#{words[1..-1].join(' ')}" means #{found.map(&:definitely).join_or}.)
              else
                actor.tell %[I recognize "#{words[0]}" but not with the rest of your sentence. (Maybe it's a one-word command?)]
              end
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
