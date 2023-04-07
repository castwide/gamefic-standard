Gamefic.script do
  respond :give, available, children do |actor, _character, _gift|
    actor.tell 'Nothing happens.'
  end

  respond :give, available(Character), available do |actor, character, gift|
    actor.tell "#{The character} doesn't want #{the gift}."
  end

  respond :give, available(Character), available do |actor, _character, gift|
    if gift.parent != actor
      actor.execute :take, gift
    end
    if gift.parent == actor
      actor.proceed
    end
  end

  interpret 'give :gift to :character', 'give :character :gift'
end
