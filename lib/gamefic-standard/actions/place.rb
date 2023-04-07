Gamefic.script do
  respond :place, children, available do |actor, thing, supporter|
    actor.tell "You can't put #{the thing} on #{the supporter}."
  end

  respond :place, available, available(Supporter) do |actor, thing, supporter|
    actor.execute :take, thing unless thing.parent == actor
    next unless thing.parent == actor
    thing.parent = supporter
    actor.tell "You put #{the thing} on #{the supporter}."
  end

  respond :place, children, available(Supporter) do |actor, thing, supporter|
    thing.parent = supporter
    actor.tell "You put #{the thing} on #{the supporter}."
  end

  interpret 'put :thing on :supporter', 'place :thing :supporter'
  interpret 'put :thing down on :supporter', 'place :thing :supporter'
  interpret 'set :thing on :supporter', 'place :thing :supporter'
  interpret 'set :thing down on :supporter', 'place :thing :supporter'
  interpret 'drop :thing on :supporter', 'place :thing :supporter'
  interpret 'place :thing on :supporter', 'place :thing :supporter'
end
