Gamefic.script do
  meta nil, plaintext do |actor, string|
    words = string.keywords
    # @todo There should probably be an Active#verbs or Active#command_words method
    list = actor.playbooks.flat_map(&:synonyms)
    if list.include?(words[0].to_sym)
      if words.length > 1
        found = []
        avail = available(ambiguous: true)
        result = avail.query(actor, words[1..-1].join(' '))
        until result.match.nil?
          found.concat result.match
          result = avail.query(actor, result.remainder)
        end
        if found.empty?
          actor.tell %(I recognize "#{words[0]}" as a verb but don't know what you mean by "#{words[1..-1].join(' ')}.")
        elsif result.remainder != ''
          actor.tell %(I recognize "#{words[0]}" as a verb but was confused by "#{result.remainder}.")
        elsif found.one?
          actor.tell %(I recognize "#{words[0]}" and "#{found.first.name}" but could not understand them together.)
        else
          actor.tell %(I recognize "#{words[0]} I'm not sure if "#{words[1..-1].join(' ')}" means #{found.map(&:definitely).join_or}.)
        end
      else
        actor.tell %(I recognize "#{words[0]}" as a verb but could not understand it in this context.)
      end
    else
      actor.tell %(I don't recognize "#{words[0]}" as a verb.)
    end
  end
end
