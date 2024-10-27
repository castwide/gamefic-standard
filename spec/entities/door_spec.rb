RSpec.describe Gamefic::Standard::Door do
  it 'opens both sides' do
    room1 = Gamefic::Standard::Room.new
    room2 = Gamefic::Standard::Room.new
    portal1, portal2 = room1.connect room2, type: Gamefic::Standard::Door
    portal1.open
    expect(portal1).to be_open
    expect(portal2).to be_open
  end

  it 'closes both sides' do
    room1 = Gamefic::Standard::Room.new
    room2 = Gamefic::Standard::Room.new
    portal1, portal2 = room1.connect room2, type: Gamefic::Standard::Door
    portal1.close
    expect(portal1).to be_closed
    expect(portal2).to be_closed
  end

  it 'supports two-way locks' do
    room1 = Gamefic::Standard::Room.new
    room2 = Gamefic::Standard::Room.new
    key = Gamefic::Standard::Item.new
    portal1, portal2 = room1.connect room2, type: Gamefic::Standard::Door
    portal1.two_way_lock_key = key
    expect(portal2.lock_key).to be(key)
  end

  it 'locks both sides' do
    room1 = Gamefic::Standard::Room.new
    room2 = Gamefic::Standard::Room.new
    portal1, portal2 = room1.connect room2, type: Gamefic::Standard::Door
    portal1.locked = true
    expect(portal2).to be_locked
  end

  it 'unlocks both sides' do
    room1 = Gamefic::Standard::Room.new
    room2 = Gamefic::Standard::Room.new
    portal1, portal2 = room1.connect room2, type: Gamefic::Standard::Door
    portal1.locked = true
    portal2.locked = false
    expect(portal1).to be_unlocked
  end
end
