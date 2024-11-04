RSpec.describe Gamefic::Standard::Lockable do
  it 'unlocks objects with keys' do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room, name: 'room'
      construct :key, Gamefic::Standard::Thing, name: 'key'

      construct :container, Gamefic::Standard::Container,
                name: 'safe',
                parent: room,
                locked: true,
                lock_key: key

      introduction do |actor|
        actor.parent = room
        key.parent = actor
      end
    end
    plot = @klass.new
    actor = plot.introduce
    actor.perform 'unlock safe with key'
    expect(plot.pick('safe')).not_to be_locked
  end

  it 'does not unlock with wrong key' do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room, name: 'room'
      construct :wrong_key, Gamefic::Standard::Thing, name: 'wrong key'
      seed { make Gamefic::Standard::Thing, name: 'right key', parent: room }
      seed { make Gamefic::Standard::Container, name: 'safe', parent: room, locked: true }

      introduction do |actor|
        actor.parent = room
        wrong_key.parent = actor
      end
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'unlock safe with wrong key'
    expect(plot.pick('safe')).to be_locked
  end

  it 'locks objects with keys' do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room, name: 'room'
      construct :key, Gamefic::Standard::Thing, name: 'key'
      seed { make Gamefic::Standard::Container, name: 'safe', parent: room, locked: false, lock_key: key }

      introduction do |actor|
        actor.parent = room
        key.parent = actor
      end
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'lock safe with key'
    expect(plot.pick('safe')).to be_locked
  end

  it 'does not open locked objects' do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room, name: 'room'
      seed { make Gamefic::Standard::Container, name: 'safe', parent: room, locked: true }

      introduction do |actor|
        actor.parent = room
      end
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'open safe'
    expect(plot.pick('safe')).not_to be_open
  end

  it 'opens closed objects without keys' do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room, name: 'room'
      seed { make Gamefic::Standard::Container, name: 'safe', parent: room, open: false }

      introduction do |actor|
        actor.parent = room
      end
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'open safe'
    expect(plot.pick('safe')).to be_open
  end

  it 'cannot be simultaneously open and locked' do
    safe = Gamefic::Standard::Container.new name: 'safe', open: true, locked: true
    expect(safe).to be_closed
    expect(safe).to be_locked
  end

  it 'cannot be simultaneously closed and unlocked' do
    safe = Gamefic::Standard::Container.new name: 'safe', open: false, locked: false
    expect(safe).to be_closed
    expect(safe).not_to be_locked
  end

  it 'opens closed and unlocked objects' do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room, name: 'room'
      construct :key, Gamefic::Standard::Thing, name: 'key'
      seed { make Gamefic::Standard::Container, name: 'safe', parent: room, locked: false, open: false, lock_key: key }

      introduction do |actor|
        actor.parent = room
      end
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'open safe'
    expect(plot.pick('safe')).to be_open
  end

  it 'reports unlockable entities' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room
    plot.make Gamefic::Standard::Thing, name: 'thing', parent: room
    player = plot.introduce
    player.parent = room
    player.perform 'lock thing'
    expect(player.messages).to include("can't lock")
  end
end
