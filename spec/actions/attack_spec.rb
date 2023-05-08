RSpec.describe 'Attack action' do
  let(:plot) { Gamefic::Plot.new }

  let(:player) {
    player = plot.make_player_character
    plot.introduce player
    player
  }

  it 'responds to specific attacks' do
    room = plot.make(Room, name: 'room')
    thing = plot.make(Thing, name: 'thing', parent: room)
    player.parent = room
    player.perform 'attack thing'
    expect(player.messages).to include('Violence is not the answer')
  end

  it 'responds to general attacks' do
    player.perform 'attack'
    expect(player.messages).to include('Violence is not the answer')
  end
end
