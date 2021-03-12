Gamefic.script do
  respond :wear, Use.available(Clothing) do |actor, clothing|
    actor.perform :take, clothing unless clothing.parent == actor
    next unless clothing.parent == actor
    if clothing.attached?
      actor.tell "You're already wearing #{the clothing}."
    else
      already = actor.children.that_are(clothing.class).that_are(:attached?)
      if already.length == 0
        clothing.attached = true
        actor.tell "You put on #{the clothing}."
      else
        actor.tell "You're already wearing #{an already[0]}."
      end
    end
  end

  interpret "put on :clothing", "wear :clothing"
  interpret "put :clothing on", "wear :clothing"
  interpret "don :clothing", "wear :clothing"
end
