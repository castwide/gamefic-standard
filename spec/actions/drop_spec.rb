RSpec.describe 'Drop action' do
  it 'drops held objects' do
    TestPlot.script do
      thing = make Thing, name: 'thing'
      introduction do |actor|
        thing.parent = actor
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'drop thing'
    expect(actor.children).to be_empty
  end

  it 'responds to objects not in inventory' do
    TestPlot.script do
      room = make Room
      make Thing, name: 'thing', parent: room
      introduction do |actor|
        actor.parent = room
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
end
