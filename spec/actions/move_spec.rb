RSpec.describe 'Move action' do
  let(:plot) { TestPlot.new }

  let(:player) {
    player = plot.introduce
    player
  }

  it 'suggests taking portable items' do
    room = plot.make(Room, name: 'room')
    item = plot.make(Item, name: 'item', parent: room)
    player.parent = room
    player.perform 'move item'
    expect(player.messages).to include('take')
  end

  it 'does not move things by default' do
    room = plot.make(Room, name: 'room')
    item = plot.make(Fixture, name: 'fixture', parent: room)
    player.parent = room
    player.perform 'move fixture'
    expect(player.messages).to include("can't move")
  end

  it 'reports items already carried' do
    room = plot.make(Room, name: 'room')
    item = plot.make(Item, name: 'item', parent: player)
    player.parent = room
    player.perform 'move item'
    expect(player.messages).to include('already carrying')
  end
end
