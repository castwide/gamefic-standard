Gamefic.script do
  meta nil, Gamefic::Query::Text.new() do |actor, string|
    words = string.split_words
    list = verbs
    if list.include?(words[0])
      if words.length > 1
        found = Gamefic::Query::Ambiguous.new.context_from(actor)
        if found.length < 2
          actor.tell "I recognize '#{words[0]}' as a verb but could not understand the rest of your sentence."
        else
          actor.tell %(I'm not sure if "#{words[1..-1].join(' ')}" means #{found.map(&:definitely).join_or}.)
        end
      else
        actor.tell "I recognize '#{words[0]}' as a verb but could not understand it in this context."
      end
    else
      actor.tell "I don't recognize '#{words[0]}' as a verb."
    end
  end

  meta nil, Gamefic::Query::Text.new(/^it$/) do |actor, string|
    words = string.split_words
    if verbs(to_s: true).include?(words[0])
      actor.tell "I'm not sure what you mean by \"it.\""
    else
      actor.proceed
    end
  end
end
