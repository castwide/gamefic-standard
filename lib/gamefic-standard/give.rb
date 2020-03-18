# @gamefic.script standard/give

respond :give, Use.available, Gamefic::Query::Children.new do |actor, _character, gift|
  actor.tell "Nothing happens."
end

respond :give, Use.available(Character), Use.available do |actor, character, gift|
  if gift.sticky?
    actor.tell gift.sticky_message || "You need to keep #{the gift} for now."
  else
    actor.tell "#{The character} doesn't want #{the gift}."
  end
end

respond :give, Use.available(Character), Use.available do |actor, _character, gift|
  if gift.parent == actor
    actor.proceed
  else
    actor.tell "You don't have #{the gift}."
  end
end

respond :give, Use.text, Use.available do |actor, character, _gift|
  actor.tell "You don't see any \"#{character}\" here."
end

interpret "give :gift to :character", "give :character :gift"
