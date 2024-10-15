RSpec.describe 'Take action' do
  it 'takes items' do
    @klass.seed do
      @room = make Room
      @thing = make Item, name: 'item', parent: @room
    end
    @klass.script do
      introduction do |actor|
        actor.parent = @room
      end
    end
    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'take item'
    expect(actor.children.first.name).to eq('item')
  end

  it 'takes items from receptacles implicitly' do
    @klass.seed do
      @room = make Room
      @receptacle = make Receptacle, name: 'receptacle', parent: @room
      make Item, name: 'item', parent: @receptacle
    end
    @klass.script do
      introduction do |actor|
        actor.parent = @room
      end
    end
    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'take item'
    expect(actor.children.first.name).to eq('item')
  end

  it 'takes items from receptacles explicitly' do
    @klass.seed do
      @room = make Room
      @receptacle = make Receptacle, name: 'receptacle', parent: @room
      make Item, name: 'item', parent: @receptacle
    end
    @klass.script do
      introduction do |actor|
        actor.parent = @room
      end
    end
    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'take item from receptacle'
    expect(actor.children.first.name).to eq('item')
  end

  it 'reports items already in possession' do
    @klass.seed do
      @thing = make Item, name: 'thing'
    end
    @klass.script do
      introduction do |actor|
        @thing.parent = actor
      end
    end
    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'take thing'
    expect(actor.messages).to include('already carrying')
  end

  it 'does not take non-portable entities' do
    @klass.seed do
      @room = make Room
      @thing = make Thing, name: 'thing', portable: false, parent: @room
    end
    @klass.script do
      introduction do |actor|
        actor.parent = @room
      end
    end
    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'take thing'
    expect(actor.messages).to include("can't take")
    expect(plot.pick('thing').parent).not_to be(actor)
  end

  it 'does not take attached entities' do
    @klass.seed do
      @room = make Room
      @thing = make Thing, name: 'thing', parent: @room
      @attachment = make Item, name: 'attachment', parent: @thing, attached: true
    end
    @klass.script do
      introduction do |actor|
        actor.parent = @room
      end
    end
    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'take attachment'
    expect(actor.messages).to include('attached')
    expect(plot.pick('attachment').parent).not_to be(actor)
  end

  it 'does not take rubble' do
    @klass.seed do
      @room = make Room
      make Rubble, name: 'rubble', parent: @room
    end
    @klass.script do
      introduction do |actor|
        actor.parent = @room
      end
    end
    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'take rubble'
    expect(plot.pick('rubble').parent).not_to be(actor)
  end

  it 'handles unmatched text' do
    plot = @klass.new
    room = plot.make Room
    plot.make Item, name: 'item1', parent: room
    actor = plot.introduce
    actor.parent = room
    actor.perform 'take item2'
    expect(actor.messages).to include("don't know", "item2")
    expect(actor.children).to be_empty
  end

  it 'takes all' do
    plot = @klass.new
    room = plot.make Room
    item1 = plot.make Item, name: 'item1', parent: room
    item2 = plot.make Item, name: 'item2', parent: room
    actor = plot.introduce
    actor.parent = room
    actor.perform 'take all'
    expect(actor.children).to eq([item1, item2])
  end
end
