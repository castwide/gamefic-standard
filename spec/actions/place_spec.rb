RSpec.describe 'place action' do
  it 'places a child on a supporter' do
    @klass.instance_exec do
      construct :room, Room, name: 'room'
      construct :thing, Thing, name: 'thing'
      construct :supporter, Supporter, name: 'supporter', parent: room

      introduction do |actor|
        actor.parent = room
        thing.parent = actor
      end
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'place thing supporter'
    expect(plot.entities[1].parent).to eq(plot.entities[2])
  end

  it 'takes and places an item on a supporter' do
    @klass.instance_exec do
      construct :room, Room, name: 'room'
      construct :item, Item, name: 'item', parent: room
      construct :supporter, Supporter, name: 'supporter', parent: room

      introduction do |actor|
        actor.parent = room
      end
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'place item supporter'
    expect(plot.entities[1].parent).to eq(plot.entities[2])
  end

  it 'rejects placement on non-supporters' do
    @klass.instance_exec do
      construct :room, Room, name: 'room'
      construct :item, Item, name: 'item'
      construct :thing, Thing, name: 'thing', parent: room

      introduction do |actor|
        actor.parent = room
        item.parent = actor
      end
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'put item on thing'
    expect(plot.pick('item').parent).to be(actor)
    expect(actor.messages).to include("can't put")
  end
end
