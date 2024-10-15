RSpec.describe 'Leave action' do
  it 'leaves an enterable' do
    @klass.instance_exec do
      construct :room, Room, name: 'room'
      construct :enterable, Container, name: 'enterable', parent: room, enterable: true

      introduction do |actor|
        actor.parent = enterable
      end
    end

    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'leave'
    expect(actor.parent.name).to eq('room')
  end

  it 'leaves a room' do
    @klass.instance_exec do
      construct :room1, Room, name: 'room 1'
      construct :room2, Room, name: 'room 2', north: room1

      introduction do |actor|
        actor.parent = room1
      end
    end

    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'leave'
    expect(actor.parent.name).to eq('room 2')
  end

  it 'stays in parents without exits' do
    @klass.instance_exec do
      construct :room, Room, name: 'room'
      construct :thing, Thing, name: 'thing', parent: room

      introduction do |actor|
        actor.parent = thing
      end
    end

    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'leave'
    expect(actor.parent.name).to eq('thing')
  end

  it 'stays in rooms without exits' do
    @klass.instance_exec do
      construct :room1, Room, name: 'room 1'
      construct :room2, Room, name: 'room 2'

      introduction do |actor|
        actor.parent = room1
      end
    end

    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'leave'
    expect(actor.parent.name).to eq('room 1')
  end

  it 'reports multiple ways to leave' do
    @klass.instance_exec do
      construct :room1, Room, name: 'room 1'
      construct :room2, Room, name: 'room 2', south: room1
      construct :room3, Room, name: 'room 3', north: room1

      introduction do |actor|
        actor.parent = room1
      end
    end

    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'leave'
    expect(actor.parent.name).to eq('room 1')
    expect(actor.messages).to include('north')
    expect(actor.messages).to include('south')
  end

  it 'opens entered containers' do
    plot = @klass.new
    room = plot.make Room
    container = plot.make Container, name: 'container', enterable: true, open: false, parent: room
    actor = plot.introduce
    actor.parent = container
    actor.perform 'leave container'
    expect(container).to be_open
    expect(actor.parent).to eq(room)
  end

  it 'handles nil parents' do
    plot = @klass.new
    actor = plot.introduce
    actor.perform 'leave'
    expect(actor.parent).to be_nil
  end
end
