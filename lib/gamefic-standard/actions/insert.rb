Gamefic.script do
  respond :insert, Use.available, Use.available do |actor, thing, target|
    actor.tell "You can't put #{the thing} inside #{the target}."
  end

  respond :insert, Use.available, Use.available(Receptacle) do |actor, thing, receptacle|
    actor.execute :take, thing unless thing.parent == actor
    next unless thing.parent == actor
    thing.parent = receptacle
    actor.tell "You put #{the thing} in #{the receptacle}."
  end

  respond :insert, Use.available, Use.available(Container) do |actor, _thing, container|
    if container.open?
      actor.proceed
    else
      actor.tell "#{The container} is closed."
    end
  end

  interpret "drop :item in :container", "insert :item :container"
  interpret "put :item in :container", "insert :item :container"
  interpret "place :item in :container", "insert :item :container"
  interpret "insert :item in :container", "insert :item :container"

  interpret "drop :item inside :container", "insert :item :container"
  interpret "put :item inside :container", "insert :item :container"
  interpret "place :item inside :container", "insert :item :container"
  interpret "insert :item inside :container", "insert :item :container"

  interpret "drop :item into :container", "insert :item :container"
  interpret "put :item into :container", "insert :item :container"
  interpret "place :item into :container", "insert :item :container"
  interpret "insert :item into :container", "insert :item :container"
end
