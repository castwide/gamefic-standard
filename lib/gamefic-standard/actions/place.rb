Gamefic.script do
  respond :place, Use.children, Use.reachable do |actor, thing, supporter|
    actor.tell "You can't put #{the thing} on #{the supporter}."
  end

  respond :place, Use.available, Use.available(Supporter) do |actor, thing, supporter|
    actor.perform :take, thing unless thing.parent == actor
    next unless thing.parent == actor
    thing.parent = supporter
    actor.tell "You put #{the thing} on #{the supporter}."
  end

  respond :place, Use.children, Use.reachable(Supporter) do |actor, thing, supporter|
    thing.parent = supporter
    actor.tell "You put #{the thing} on #{the supporter}."
  end

  respond :place, Use.text, Use.text do |actor, thing, supporter|
    actor.tell "I don't know what you mean by \"#{thing}\" or \"#{supporter}.\""
  end

  interpret "put :thing on :supporter", "place :thing :supporter"
  interpret "put :thing down on :supporter", "place :thing :supporter"
  interpret "set :thing on :supporter", "place :thing :supporter"
  interpret "set :thing down on :supporter", "place :thing :supporter"
  interpret "drop :thing on :supporter", "place :thing :supporter"
  interpret "place :thing on :supporter", "place :thing :supporter"
end
