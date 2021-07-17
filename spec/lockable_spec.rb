RSpec.describe Lockable do
  it 'unlocks objects with keys' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      key = make Thing, name: 'key'
      safe_class = Class.new(Thing)
      safe_class.include Lockable
      make safe_class, name: 'safe', parent: room, locked: true, lock_key: key
      introduction do |actor|
        actor.parent = room
        key.parent = actor
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'unlock safe with key'
    expect(plot.pick('safe')).not_to be_locked
  end

  it 'does not unlock with wrong key' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      wrong_key = make Thing, name: 'wrong key'
      make Thing, name: 'right key', parent: room
      safe_class = Class.new(Thing)
      safe_class.include Lockable
      make safe_class, name: 'safe', parent: room, locked: true
      introduction do |actor|
        actor.parent = room
        wrong_key.parent = actor
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'unlock safe with wrong key'
    expect(plot.pick('safe')).to be_locked
  end

  it 'locks objects with keys' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      key = make Thing, name: 'key'
      safe_class = Class.new(Thing)
      safe_class.include Lockable
      make safe_class, name: 'safe', parent: room, locked: false, lock_key: key
      introduction do |actor|
        actor.parent = room
        key.parent = actor
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'lock safe with key'
    expect(plot.pick('safe')).to be_locked
  end

  it 'does not open locked objects' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      safe_class = Class.new(Thing)
      safe_class.include Lockable
      make safe_class, name: 'safe', parent: room, locked: true
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'open safe'
    expect(plot.pick('safe')).not_to be_open
  end

  it 'opens closed objects without keys' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      safe_class = Class.new(Thing)
      safe_class.include Lockable
      make safe_class, name: 'safe', parent: room, open: false
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'open safe'
    expect(plot.pick('safe')).to be_open
  end

  it 'cannot be simultaneously open and locked' do
    plot = Gamefic::Plot.new
    safe_class = Class.new(Thing)
    safe_class.include Lockable
    safe = plot.make safe_class, name: 'safe', open: true, locked: true
    expect(safe).to be_closed
    expect(safe).to be_locked
  end

  it 'can be closed and unlocked' do
    plot = Gamefic::Plot.new
    safe_class = Class.new(Thing)
    safe_class.include Lockable
    safe = plot.make safe_class, name: 'safe', open: false, locked: false
    expect(safe).to be_closed
    expect(safe).not_to be_locked
  end

  it 'opens closed and unlocked objects' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      safe_class = Class.new(Thing)
      safe_class.include Lockable
      key = make Thing, name: 'key'
      make safe_class, name: 'safe', parent: room, locked: false, open: false, lock_key: key
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'open safe'
    expect(plot.pick('safe')).to be_open
  end

  it 'reports unlockable entities' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    plot.make Thing, name: 'thing', parent: room
    player = plot.make_player_character
    plot.introduce player
    player.parent = room
    player.perform 'lock thing'
    expect(player.messages).to include("can't lock")
  end
end
