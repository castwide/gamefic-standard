Gamefic::Standard.script do
  respond :wait do |actor|
    actor.tell "Time passes."
  end

  interpret 'z', 'wait'
end
