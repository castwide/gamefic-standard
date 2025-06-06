RSpec.describe 'Take action' do
  it 'takes items' do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room, name: 'room'
      construct :thing, Gamefic::Standard::Item, name: 'thing', parent: room

      introduction do |actor|
        actor.parent = room
      end
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'take thing'
    expect(actor.children).to include(plot.thing)
  end

  it 'takes items from receptacles implicitly' do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room
      construct :receptacle, Gamefic::Standard::Receptacle, name: 'receptacle', parent: room
      construct :item, Gamefic::Standard::Item, name: 'item', parent: receptacle

      introduction do |actor|
        actor.parent = room
      end
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'take item'
    expect(actor.children.first.name).to eq('item')
  end

  it 'takes items from receptacles explicitly' do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room
      construct :receptacle, Gamefic::Standard::Receptacle, name: 'receptacle', parent: room
      construct :item, Gamefic::Standard::Item, name: 'item', parent: receptacle

      introduction do |actor|
        actor.parent = room
      end
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'take item from receptacle'
    expect(actor.children.first.name).to eq('item')
  end

  it 'reports items already in possession' do
    @klass.instance_exec do
      construct :thing, Gamefic::Standard::Item, name: 'thing'

      introduction do |actor|
        thing.parent = actor
      end
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'take thing'
    expect(actor.messages).to include('already carrying')
  end

  it 'does not take non-portable entities' do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room
      construct :thing, Gamefic::Standard::Thing, name: 'thing', portable: false, parent: room

      introduction { |actor| actor.parent = room }
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'take thing'
    expect(actor.messages).to include("can't take")
    expect(plot.pick('thing').parent).not_to be(actor)
  end

  it 'does not take attached entities' do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room
      construct :thing, Gamefic::Standard::Thing, name: 'thing', parent: room
      construct :attachment, Gamefic::Standard::Item, name: 'attachment', parent: thing, attached: true
      introduction { |actor| actor.parent = room }
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'take attachment'
    expect(actor.messages).to include('attached')
    expect(plot.pick('attachment').parent).not_to be(actor)
  end

  it 'does not take rubble' do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room, name: 'room'
      construct :rubble, Gamefic::Standard::Rubble, name: 'rubble', parent: room

      introduction do |actor|
        actor.parent = room
      end
    end
    plot = @klass.new
    actor = plot.introduce
    actor.perform 'take rubble'
    expect(plot.pick('rubble').parent).not_to be(actor)
  end

  it 'handles unmatched text' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room
    plot.make Gamefic::Standard::Item, name: 'item1', parent: room
    actor = plot.introduce
    actor.parent = room
    actor.perform 'take item2'
    expect(actor.messages).to include("don't know", "item2")
    expect(actor.children).to be_empty
  end

  it 'takes all' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room
    item1 = plot.make Gamefic::Standard::Item, name: 'item1', parent: room
    item2 = plot.make Gamefic::Standard::Item, name: 'item2', parent: room
    actor = plot.introduce
    actor.parent = room
    actor.perform 'take all'
    expect(actor.children).to eq([item1, item2])
  end
end
