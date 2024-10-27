RSpec.describe 'Search action' do
  let(:plot) { @klass.new }

  it 'opens containers before searching' do
    room = plot.make Gamefic::Standard::Room
    container = plot.make Gamefic::Standard::Container, name: 'container', open: false, parent: room
    item = plot.make Gamefic::Standard::Item, name: 'item', parent: container
    player = plot.introduce
    player.parent = room
    player.perform 'look inside container'
    expect(container).to be_open
    expect(player.messages).to include('item')
  end

  it 'does not search unopenable containers' do
    room = plot.make Gamefic::Standard::Room
    container = plot.make Gamefic::Standard::Container, name: 'container', open: false, locked: true, parent: room
    item = plot.make Gamefic::Standard::Item, name: 'item', parent: container
    player = plot.introduce
    player.parent = room
    player.perform 'look inside container'
    expect(container).to be_closed
    expect(player.messages).not_to include('item')
  end

  it 'reports empty receptacles' do
    room = plot.make Gamefic::Standard::Room
    _receptacle = plot.make Gamefic::Standard::Receptacle, name: 'receptacle', parent: room
    player = plot.introduce
    player.parent = room
    player.perform 'look inside receptacle'
    expect(player.messages).to include('nothing inside')
  end

  it 'reverts to look' do
    room = plot.make Gamefic::Standard::Room
    thing = plot.make Gamefic::Standard::Thing, name: 'thing', description: 'Just a thing.', parent: room
    player = plot.introduce
    player.parent = room
    player.perform 'search thing'
    expect(player.messages).to include(thing.description)
  end

  it 'reports inaccessible receptacles' do
    room = plot.make Gamefic::Standard::Room
    receptacle = plot.make(Gamefic::Standard::Receptacle, name: 'receptacle', parent: room)
    receptacle.define_singleton_method :accessible? do
      false
    end
    player = plot.introduce
    player.parent = room
    player.perform 'search receptacle'
    expect(player.messages).to include("can't see inside")
  end
end
