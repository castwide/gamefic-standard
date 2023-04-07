RSpec.describe Door do
  it 'synchronizes open statuses' do
    plot = Gamefic::Plot.new
    room1 = plot.make Room, name: 'room1'
    room2 = plot.make Room, name: 'room2'
    door = plot.connect room1, room2, 'east', type: Door
    door.open = true
    expect(door.reverse).to be_open
    door.open = false
    expect(door.reverse).to be_closed
  end

  it 'synchronizes lock statuses' do
    plot = Gamefic::Plot.new
    room1 = plot.make Room, name: 'room1'
    room2 = plot.make Room, name: 'room2'
    key = plot.make Item, name: 'key'
    door = plot.connect room1, room2, 'east', type: Door
    door.two_way_lock_key = key
    expect(door.reverse.lock_key).to be(key)
    door.locked = true
    expect(door).to be_locked
    expect(door.reverse).to be_locked
    door.locked = false
    expect(door).to be_unlocked
    expect(door.reverse).to be_unlocked
  end

  it 'synchronizes one-way lock statuses' do
    plot = Gamefic::Plot.new
    room1 = plot.make Room, name: 'room1'
    room2 = plot.make Room, name: 'room2'
    key = plot.make Item, name: 'key'
    door = plot.connect room1, room2, 'east', type: Door
    door.lock_key = key
    expect(door.reverse.lock_key).to be_nil
    door.locked = true
    expect(door).to be_locked
    expect(door.reverse).to be_locked
    door.locked = false
    expect(door).to be_unlocked
    expect(door.reverse).to be_unlocked
  end

  it 'tries to open doors before going' do
    plot = Gamefic::Plot.new
    room1 = plot.make Room, name: 'room1'
    room2 = plot.make Room, name: 'room2'
    door = plot.connect room1, room2, 'east', type: Door
    door.open = false
    actor = plot.make_player_character
    plot.introduce actor
    actor.parent = room1
    expect(door).to be_closed
    actor.perform 'go east'
    expect(actor.parent).to eq(room2)
    expect(door).to be_open
  end
end
