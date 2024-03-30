# frozen_string_literal: true

Gamefic::Standard.script do
  # Save, Restore, and Undo need to be handled by the game client. They have
  # default implementations here to make them available in help.

  meta :save do |actor|
    actor.tell "<kbd>Save</kbd> is not available."
  end

  meta :restore do |actor|
    actor.tell "<kbd>Restore</kbd> is not available."
  end

  meta :undo do |actor|
    actor.tell "<kbd>Undo</kbd> is not available."
  end
end
