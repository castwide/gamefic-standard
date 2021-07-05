Gamefic.script do
  respond :give, Use.available, Gamefic::Query::Children.new do |actor, _character, _gift|
    actor.tell 'Nothing happens.'
  end

  respond :give, Use.available(Character), Use.available do |actor, character, gift|
    actor.tell "#{The character} doesn't want #{the gift}."
  end

  respond :give, Use.available(Character), Use.available do |actor, _character, gift|
    if gift.parent != actor
      actor.perform :take, gift
    end
    if gift.parent == actor
      actor.proceed
    end
  end

  interpret 'give :gift to :character', 'give :character :gift'
end
