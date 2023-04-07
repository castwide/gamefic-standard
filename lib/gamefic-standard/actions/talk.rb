Gamefic.script do
  respond :talk do |actor|
    actor.tell "You talk to yourself."
  end

  respond :talk, myself do |actor, yourself|
    actor.execute :talk
  end

  respond :talk, available do |actor, thing|
    actor.tell "Nothing happens."
  end

  respond :talk, available(Character) do |actor, character|
    actor.tell "#{The character} has nothing to say."
  end

  interpret "talk to :character", "talk :character"
  interpret "talk to :character about :subject", "talk :character :subject"
  interpret "ask :character :subject", "talk :character :subject"
  interpret "ask :character about :subject", "talk :character :subject"
  interpret "tell :character :subject", "talk :character :subject"
  interpret "tell :character about :subject", "talk :character :subject"
  interpret "ask :character for :subject", "talk :character :subject"
end
