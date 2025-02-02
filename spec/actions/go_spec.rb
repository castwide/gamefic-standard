RSpec.describe 'Go action' do
  it 'goes through a portal' do
    @klass.instance_exec do
      construct :room1, Gamefic::Standard::Room, name: 'room1'
      construct :room2, Gamefic::Standard::Room, name: 'room2', west: room1

      introduction do |actor|
        actor.parent = room1
      end
    end
    plot = @klass.new
    actor = plot.introduce
    actor.perform 'go east'
    expect(actor.parent.name).to eq('room2')
  end

  it 'ignores portals without destinations' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    plot.make Gamefic::Standard::Portal, name: 'portal', parent: room
    actor = plot.introduce
    actor.parent = room
    actor.perform 'go portal'
    expect(actor.messages).to include('nowhere')
    expect(actor.parent).to eq(room)
  end

  it 'leaves supporters before using portals' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    chair = plot.make Gamefic::Standard::Supporter, name: 'chair', enterable: true, parent: room
    out = plot.make Gamefic::Standard::Room, name: 'out'
    room.connect out, direction: 'east'
    actor = plot.introduce
    actor.parent = chair
    actor.perform 'go east'
    expect(actor.parent).to eq(out)
    expect(actor.messages).to include('get off the chair')
  end

  it 'leaves supporters and reports unknown portals' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    chair = plot.make Gamefic::Standard::Supporter, name: 'chair', enterable: true, parent: room
    out = plot.make Gamefic::Standard::Room, name: 'out'
    room.connect out, direction: 'east'
    actor = plot.introduce
    actor.parent = chair
    actor.perform 'go west'
    expect(actor.parent).to eq(room)
    expect(actor.messages).to include('get off the chair')
  end

  it 'fails if supporter cannot be left' do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room, name: 'room'
      construct :chair, Gamefic::Standard::Supporter, name: 'chair', enterable: true, parent: room
      construct :out, Gamefic::Standard::Room, name: 'out', west: room

      respond :leave, parent(chair) do |actor, _chair|
        actor.tell "You can't leave the chair."
      end

      introduction do |actor|
        actor.parent = chair
      end
    end
    plot = @klass.new
    actor = plot.introduce
    actor.perform 'go east'
    expect(actor.parent).to eq(plot.chair)
    expect(actor.messages).to include("You can't leave the chair.")
  end
end
