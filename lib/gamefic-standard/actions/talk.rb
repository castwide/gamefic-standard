Gamefic::Standard.script do
  respond :talk do |actor|
    actor.tell "You talk to yourself."
  end

  respond :talk, myself do |actor, yourself|
    actor.execute :talk
  end

  respond :talk, available do |actor, thing|
    actor.tell "Nothing happens."
  end

  respond :talk, Character do |actor, character|
    actor.tell "#{The character} has nothing to say."
  end

  respond :talk, Character, plaintext do |actor, character, text|
    actor.tell "#{The character} has nothing to say about #{text}."
  end

  interpret "talk to :character", "talk :character"
  interpret "talk to :character about :subject", "talk :character :subject"
  interpret "ask :character :subject", "talk :character :subject"
  interpret "ask :character about :subject", "talk :character :subject"
  interpret "tell :character :subject", "talk :character :subject"
  interpret "tell :character about :subject", "talk :character :subject"
  interpret "ask :character for :subject", "talk :character :subject"
  interpret "speak :character", "talk :character"
  interpret "speak to :character", "talk :character"
  interpret "speak :character :subject", "talk :character :subject"
  interpret "speak :character about :subject", "talk :character :subject"
  interpret "speak to :character about :subject", "talk :character :subject"
  interpret "speak to :character :subject", "talk :character :subject"
  interpret "discuss :subject :character", "talk :character :subject"
  interpret "discuss :subject with :character", "talk :character :subject"
end
