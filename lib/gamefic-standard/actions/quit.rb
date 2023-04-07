Gamefic.script do
  yes_or_no :confirm_quit do |scene|
    scene.on_finish do |actor, data|
      actor.cue :default_conclusion if data.yes?
    end
  end

  meta :quit do |actor|
    actor.tell "Are you sure you want to quit?"
    actor.cue :confirm_quit
  end
end
