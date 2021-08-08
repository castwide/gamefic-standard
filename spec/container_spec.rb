RSpec.describe 'Look in container action' do
  it 'opens before looking inside' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    container = plot.make Container, name: 'container', open: false, parent: room
    item = plot.make Item, name: 'item', parent: container
    player = plot.make_player_character
    plot.introduce player
    player.parent = room
    player.perform 'look inside container'
    expect(container).to be_open
    expect(player.messages).to include('item')
  end

  it 'does not look inside unopenable containers' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    container = plot.make Container, name: 'container', open: false, locked: true, parent: room
    item = plot.make Item, name: 'item', parent: container
    player = plot.make_player_character
    plot.introduce player
    player.parent = room
    player.perform 'look inside container'
    expect(container).to be_closed
    expect(player.messages).not_to include('item')
  end
end
