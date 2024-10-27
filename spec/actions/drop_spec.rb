RSpec.describe 'Drop action' do
  it 'drops held objects' do
    @klass.instance_exec do
      construct :thing, Gamefic::Standard::Thing, name: 'thing'

      introduction do |actor|
        thing.parent = actor
      end
    end
    plot = @klass.new
    actor = plot.introduce
    actor.perform 'drop thing'
    expect(actor.children).to be_empty
  end

  it 'responds to objects not in inventory' do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room
      construct :thing, Gamefic::Standard::Thing, name: 'thing', parent: room

      introduction do |actor|
        actor.parent = room
      end
    end
    plot = @klass.new
    actor = plot.introduce
    actor.perform 'drop thing'
    expect(actor.messages).to include('not carrying the thing')
  end

  it 'drops things in carried receptacles' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room
    wallet = plot.make Gamefic::Standard::Receptacle, name: 'wallet', portable: true
    item = plot.make Gamefic::Standard::Item, name: 'item', parent: wallet
    actor = plot.introduce
    actor.parent = room
    wallet.parent = actor
    actor.perform 'drop item'
    expect(item.parent).to eq(room)
  end

  it 'drops all' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room
    player = plot.introduce
    player.parent = room
    thing1 = plot.make Gamefic::Standard::Item, name: 'thing1', parent: player
    thing2 = plot.make Gamefic::Standard::Item, name: 'thing2', parent: player
    player.perform 'drop all'
    expect(thing1.parent).to be(room)
    expect(thing2.parent).to be(room)
  end
end
