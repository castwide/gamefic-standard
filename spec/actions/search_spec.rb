RSpec.describe 'Search action' do
  it 'opens containers before searching' do
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

  it 'does not search unopenable containers' do
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

  it 'reports empty receptacles' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    _receptacle = plot.make Receptacle, name: 'receptacle', parent: room
    player = plot.make_player_character
    plot.introduce player
    player.parent = room
    player.perform 'look inside receptacle'
    expect(player.messages).to include('nothing inside')
  end

  it 'reverts to look' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    thing = plot.make Thing, name: 'thing', description: 'Just a thing.', parent: room
    player = plot.make_player_character
    plot.introduce player
    player.parent = room
    player.perform 'search thing'
    expect(player.messages).to include(thing.description)
  end
end
