RSpec.describe 'insert action' do
  it 'inserts a child in a receptacle' do
    @klass.instance_exec do
      construct :room, Room, name: 'room'
      construct :thing, Thing, name: 'thing'
      construct :receptacle, Receptacle, name: 'receptacle', parent: room

      introduction do |actor|
        actor.parent = room
        thing.parent = actor
      end
    end
    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'insert thing receptacle'
    expect(plot.entities[1].parent).to eq(plot.entities[2])
  end

  it 'inserts a child in an open container' do
    @klass.instance_exec do
      construct :room, Room, name: 'room'
      construct :thing, Thing, name: 'thing'
      construct :container, Container, name: 'container', parent: room, open: true

      introduction do |actor|
        actor.parent = room
        thing.parent = actor
      end
    end

    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'insert thing container'
    expect(plot.entities[1].parent).to eq(plot.entities[2])
  end

  it 'does not insert a child in a closed container' do
    @klass.instance_exec do
      construct :room, Room, name: 'room'
      construct :thing, Thing, name: 'thing'
      construct :container, Container, name: 'container', parent: @room, open: false

      introduction do |actor|
        actor.parent = room
        thing.parent = actor
      end
    end

    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'insert thing container'
    expect(plot.entities[1].parent).not_to eq(plot.entities[2])
  end

  it 'does not insert a child in a non-container' do
    @klass.instance_exec do
      construct :room, Room
      construct :thing, Thing, name: 'thing', parent: room
      construct :item, Item, name: 'item'

      introduction do |actor|
        actor.parent = room
        item.parent = actor
      end
    end
    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'put item in thing'
    expect(actor.messages).to include("can't put")
    expect(plot.pick('item').parent).to be(actor)
  end

  it 'inserts an available item in a container' do
    @klass.instance_exec do
      construct :room, Room, name: 'room'
      construct :container, Container, name: 'container', parent: room, open: true
      construct :item, Item, name: 'item', parent: room

      introduction do |actor|
        actor.parent = room
      end
    end

    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'put item in container'
    expect(plot.pick('item').parent).to be(plot.pick('container'))
  end
end
