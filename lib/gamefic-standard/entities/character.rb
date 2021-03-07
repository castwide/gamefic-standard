class Character < Thing
  include Gamefic::Active

  def gender
    @gender ||= :other
  end
end

Gamefic.script do
  set_player_class Character
end
