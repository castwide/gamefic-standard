Gamefic.script do
  yes_or_no :confirm_quit do |actor, props|
    actor.cue :default_conclusion if props.yes?
  end

  meta :quit do |actor|
    actor.tell "Are you sure you want to quit?"
    actor.cue :confirm_quit
  end
end
