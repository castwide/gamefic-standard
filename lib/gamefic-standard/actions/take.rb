Gamefic.script do
  respond :take, Use.available do |actor, thing|
    if thing.parent == actor
      actor.tell "You're already carrying #{the thing}."
    elsif thing.portable?
      if actor.parent != thing.parent
        actor.tell "You take #{the thing} from #{the thing.parent}."
      else
        actor.tell "You take #{the thing}."
      end
      thing.parent = actor
    else
      actor.tell "You can't take #{the thing}."
    end
  end

  respond :take, Use.available(:attached?) do |actor, thing|
    actor.tell "#{The thing} is attached to #{the thing.parent}."
  end

  respond :take, Use.available(Rubble) do |actor, rubble|
    actor.tell "You don't have any use for #{the rubble}."
  end

  interpret "get :thing", "take :thing"
  interpret "pick up :thing", "take :thing"
  interpret "pick :thing up", "take :thing"
  interpret "carry :thing", "take :thing"
end
