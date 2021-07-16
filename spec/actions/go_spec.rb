RSpec.describe 'Go action' do
  it 'goes through a portal' do
    plot = Gamefic::Plot.new
    plot.stage do
      room1 = make Room, name: 'room1'
      room2 = make Room, name: 'room2'
      connect room1, room2, 'east'
      introduction do |actor|
        actor.parent = room1
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'go east'
    expect(actor.parent.name).to eq('room2')
  end

  it 'ignores portals without destinations' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room'
    plot.make Portal, name: 'portal', parent: room
    actor = plot.get_player_character
    plot.introduce actor
    actor.parent = room
    actor.perform 'go portal'
    expect(actor.messages).to include('nowhere')
    expect(actor.parent).to eq(room)
  end

  it 'leaves supporters before using portals' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room'
    chair = plot.make Supporter, name: 'chair', enterable: true, parent: room
    out = plot.make Room, name: 'out'
    plot.connect room, out, 'east'
    actor = plot.make_player_character
    plot.introduce actor
    actor.parent = chair
    actor.perform 'go east'
    expect(actor.parent).to be(out)
    expect(actor.messages).to include('get off the chair')
  end

  it 'leaves supporters and reports unknown portals' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room'
    chair = plot.make Supporter, name: 'chair', enterable: true, parent: room
    out = plot.make Room, name: 'out'
    plot.connect room, out, 'east'
    actor = plot.make_player_character
    plot.introduce actor
    actor.parent = chair
    actor.perform 'go west'
    expect(actor.parent).to be(room)
    expect(actor.messages).to include('get off the chair')
  end
end
