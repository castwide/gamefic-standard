RSpec.describe 'Attack action' do
  let(:plot) { @klass.new }

  let(:player) {
    player = plot.introduce
    player
  }

  it 'responds to specific attacks' do
    room = plot.make(Gamefic::Standard::Room, name: 'room')
    plot.make(Gamefic::Standard::Thing, name: 'thing', parent: room)
    player.parent = room
    player.perform 'attack thing'
    expect(player.messages).to include('Violence is not the answer')
  end

  it 'responds to general attacks' do
    player.perform 'attack'
    expect(player.messages).to include('Violence is not the answer')
  end
end
