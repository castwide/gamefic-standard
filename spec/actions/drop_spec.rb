RSpec.describe 'Drop action' do
  it 'drops held objects' do
    TestPlot.seed do
      @thing = make Thing, name: 'thing'
    end
    TestPlot.script do
      introduction do |actor|
        @thing.parent = actor
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'drop thing'
    expect(actor.children).to be_empty
  end

  it 'responds to objects not in inventory' do
    TestPlot.seed do
      @room = make Room
      make Thing, name: 'thing', parent: @room
    end
    TestPlot.script do
      introduction do |actor|
        actor.parent = @room
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'drop thing'
    expect(actor.messages).to include('not carrying the thing')
  end

  it 'drops things in carried receptacles' do
    plot = TestPlot.new
    room = plot.make Room
    wallet = plot.make Receptacle, name: 'wallet', portable: true
    item = plot.make Item, name: 'item', parent: wallet
    actor = plot.introduce
    plot.ready
    actor.parent = room
    wallet.parent = actor
    actor.perform 'drop item'
    expect(item.parent).to eq(room)
  end

  it 'drops all' do
    plot = TestPlot.new
    room = plot.make Room
    player = plot.introduce
    player.parent = room
    thing1 = plot.make Item, name: 'thing1', parent: player
    thing2 = plot.make Item, name: 'thing2', parent: player
    player.perform 'drop all'
    expect(thing1.parent).to be(room)
    expect(thing2.parent).to be(room)
  end
end
