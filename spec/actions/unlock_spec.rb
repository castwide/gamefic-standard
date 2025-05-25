RSpec.describe 'Unlock action' do
  it 'unlocks with key' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room
    key = plot.make Gamefic::Standard::Item, name: 'key'
    safe = plot.make Gamefic::Standard::Container, name: 'safe', lock_key: key, locked: true, parent: room
    actor = plot.introduce
    actor.parent = room
    key.parent = actor
    actor.perform 'unlock safe with key'
    expect(safe).to be_unlocked
  end

  it 'reports already unlocked' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room
    key = plot.make Gamefic::Standard::Item, name: 'key'
    _safe = plot.make Gamefic::Standard::Container, name: 'safe', lock_key: key, locked: false, parent: room
    actor = plot.introduce
    actor.parent = room
    key.parent = actor
    actor.perform 'unlock safe with key'
    expect(actor.messages).to include('already unlocked')
  end

  it 'reports incorrect keys' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room
    key = plot.make Gamefic::Standard::Item, name: 'key'
    stick = plot.make Gamefic::Standard::Item, name: 'stick'
    _safe = plot.make Gamefic::Standard::Container, name: 'safe', lock_key: key, locked: true, parent: room
    actor = plot.introduce
    actor.parent = room
    stick.parent = actor
    actor.perform 'unlock safe with stick'
    expect(actor.messages).to include("can't unlock")
  end
end
