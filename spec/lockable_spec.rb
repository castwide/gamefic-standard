RSpec.describe Gamefic::Standard::Lockable do
  it 'unlocks objects with keys' do
    TestPlot.seed do
      @room = make Room, name: 'room'
      @key = make Thing, name: 'key'
      make Container, name: 'safe', parent: @room, locked: true, lock_key: @key
    end
    TestPlot.script do
      introduction do |actor|
        actor.parent = @room
        @key.parent = actor
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'unlock safe with key'
    expect(plot.pick('safe')).not_to be_locked
  end

  it 'does not unlock with wrong key' do
    TestPlot.seed do
      @room = make Room, name: 'room'
      @wrong_key = make Thing, name: 'wrong key'
      make Thing, name: 'right key', parent: @room
      make Container, name: 'safe', parent: @room, locked: true
    end
    TestPlot.script do
      introduction do |actor|
        actor.parent = @room
        @wrong_key.parent = actor
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'unlock safe with wrong key'
    expect(plot.pick('safe')).to be_locked
  end

  it 'locks objects with keys' do
    TestPlot.seed do
      @room = make Room, name: 'room'
      @key = make Thing, name: 'key'
      make Container, name: 'safe', parent: @room, locked: false, lock_key: @key
    end
    TestPlot.script do
      introduction do |actor|
        actor.parent = @room
        @key.parent = actor
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'lock safe with key'
    expect(plot.pick('safe')).to be_locked
  end

  it 'does not open locked objects' do
    TestPlot.seed do
      @room = make Room, name: 'room'
      make Container, name: 'safe', parent: @room, locked: true
    end
    TestPlot.script do
      introduction do |actor|
        actor.parent = @room
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'open safe'
    expect(plot.pick('safe')).not_to be_open
  end

  it 'opens closed objects without keys' do
    TestPlot.seed do
      @room = make Room, name: 'room'
      make Container, name: 'safe', parent: @room, open: false
    end
    TestPlot.script do
      introduction do |actor|
        actor.parent = @room
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'open safe'
    expect(plot.pick('safe')).to be_open
  end

  it 'cannot be simultaneously open and locked' do
    safe = Container.new name: 'safe', open: true, locked: true
    expect(safe).to be_closed
    expect(safe).to be_locked
  end

  it 'cannot be simultaneously closed and unlocked' do
    safe = Container.new name: 'safe', open: false, locked: false
    expect(safe).to be_closed
    expect(safe).not_to be_locked
  end

  it 'opens closed and unlocked objects' do
    TestPlot.seed do
      @room = make Room, name: 'room'
      key = make Thing, name: 'key'
      make Container, name: 'safe', parent: @room, locked: false, open: false, lock_key: key
    end
    TestPlot.script do
      introduction do |actor|
        actor.parent = @room
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'open safe'
    expect(plot.pick('safe')).to be_open
  end

  it 'reports unlockable entities' do
    plot = TestPlot.new
    room = plot.make Room
    plot.make Thing, name: 'thing', parent: room
    player = plot.introduce
    player.parent = room
    player.perform 'lock thing'
    expect(player.messages).to include("can't lock")
  end
end
