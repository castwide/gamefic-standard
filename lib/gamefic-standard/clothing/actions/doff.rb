Gamefic.script do
  respond :doff, Gamefic::Query::Children.new(Clothing) do |actor, clothing|
    if !clothing.attached?
      actor.tell "You're not wearing #{the clothing}."
    else
      clothing.attached = false
      actor.tell "You take off #{the clothing}."
    end
  end

  interpret "remove :clothing", "doff :clothing"
  interpret "take off :clothing", "doff :clothing"
  interpret "take :clothing off", "doff :clothing"
end
