class Character < Thing
  include Gamefic::Active

  def gender
    @gender ||= :other
  end
end

Gamefic.script do
  player_class Character
end
