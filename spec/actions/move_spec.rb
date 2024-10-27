RSpec.describe 'Move action' do
  let(:plot) { @klass.new }

  let(:player) {
    player = plot.introduce
    player
  }

  it 'suggests taking portable items' do
    room = plot.make(Gamefic::Standard::Room, name: 'room')
    plot.make(Gamefic::Standard::Item, name: 'item', parent: room)
    player.parent = room
    player.perform 'move item'
    expect(player.messages).to include('take')
  end

  it 'does not move things by default' do
    room = plot.make(Gamefic::Standard::Room, name: 'room')
    plot.make(Gamefic::Standard::Fixture, name: 'fixture', parent: room)
    player.parent = room
    player.perform 'move fixture'
    expect(player.messages).to include("can't move")
  end

  it 'reports items already carried' do
    room = plot.make(Gamefic::Standard::Room, name: 'room')
    plot.make(Gamefic::Standard::Item, name: 'item', parent: player)
    player.parent = room
    player.perform 'move item'
    expect(player.messages).to include('already carrying')
  end
end
