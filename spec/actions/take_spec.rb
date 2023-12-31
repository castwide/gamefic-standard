RSpec.describe 'Take action' do
  it 'takes items' do
    TestPlot.seed do
      @room = make Room
      @thing = make Item, name: 'item', parent: @room
    end
    TestPlot.script do
      introduction do |actor|
        actor.parent = @room
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'take item'
    expect(actor.children.first.name).to eq('item')
  end

  it 'takes items from receptacles implicitly' do
    TestPlot.seed do
      @room = make Room
      @receptacle = make Receptacle, name: 'receptacle', parent: @room
      make Item, name: 'item', parent: @receptacle
    end
    TestPlot.script do
      introduction do |actor|
        actor.parent = @room
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'take item'
    expect(actor.children.first.name).to eq('item')
  end

  it 'takes items from receptacles explicitly' do
    TestPlot.seed do
      @room = make Room
      @receptacle = make Receptacle, name: 'receptacle', parent: @room
      make Item, name: 'item', parent: @receptacle
    end
    TestPlot.script do
      introduction do |actor|
        actor.parent = @room
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'take item from receptacle'
    expect(actor.children.first.name).to eq('item')
  end

  it 'reports items already in possession' do
    TestPlot.seed do
      @thing = make Item, name: 'thing'
    end
    TestPlot.script do
      introduction do |actor|
        @thing.parent = actor
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'take thing'
    expect(actor.messages).to include('already carrying')
  end

  it 'does not take non-portable entities' do
    TestPlot.seed do
      @room = make Room
      @thing = make Thing, name: 'thing', portable: false, parent: @room
    end
    TestPlot.script do
      introduction do |actor|
        actor.parent = @room
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'take thing'
    expect(actor.messages).to include("can't take")
    expect(plot.pick('thing').parent).not_to be(actor)
  end

  it 'does not take attached entities' do
    TestPlot.seed do
      @room = make Room
      @thing = make Thing, name: 'thing', parent: @room
      @attachment = make Item, name: 'attachment', parent: @thing, attached: true
    end
    TestPlot.script do
      introduction do |actor|
        actor.parent = @room
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'take attachment'
    expect(actor.messages).to include('attached')
    expect(plot.pick('attachment').parent).not_to be(actor)
  end

  it 'does not take rubble' do
    TestPlot.seed do
      @room = make Room
      make Rubble, name: 'rubble', parent: @room
    end
    TestPlot.script do
      introduction do |actor|
        actor.parent = @room
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'take rubble'
    expect(plot.pick('rubble').parent).not_to be(actor)
  end

  it 'handles unmatched text' do
    plot = TestPlot.new
    room = plot.make Room
    plot.make Item, name: 'item1', parent: room
    actor = plot.introduce
    actor.parent = room
    actor.perform 'take item2'
    expect(actor.messages).to include("don't know", "item2")
    expect(actor.children).to be_empty
  end
end
