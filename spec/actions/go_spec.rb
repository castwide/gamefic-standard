RSpec.describe 'Go action' do
  it 'goes through a portal' do
    Gamefic::Plot.script do
      room1 = make Room, name: 'room1'
      room2 = make Room, name: 'room2'
      connect room1, room2, 'east'
      introduction do |actor|
        actor.parent = room1
      end
    end
    plot = Gamefic::Plot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'go east'
    expect(actor.parent.name).to eq('room2')
  end

  it 'ignores portals without destinations' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room'
    plot.make Portal, name: 'portal', parent: room
    actor = plot.introduce
    actor.parent = room
    actor.perform 'go portal'
    expect(actor.messages).to include('nowhere')
    expect(actor.parent).to eq(room)
  end

  it 'leaves supporters before using portals' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room'
    chair = plot.make Supporter, name: 'chair', enterable: true, parent: room
    out = plot.make Room, name: 'out'
    plot.connect room, out, 'east'
    actor = plot.introduce
    actor.parent = chair
    actor.perform 'go east'
    expect(actor.parent).to eq(out)
    expect(actor.messages).to include('get off the chair')
  end

  it 'leaves supporters and reports unknown portals' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room'
    chair = plot.make Supporter, name: 'chair', enterable: true, parent: room
    out = plot.make Room, name: 'out'
    plot.connect room, out, 'east'
    actor = plot.introduce
    actor.parent = chair
    actor.perform 'go west'
    expect(actor.parent).to eq(room)
    expect(actor.messages).to include('get off the chair')
  end

  it 'fails if supporter cannot be left' do
    Gamefic::Plot.seed do
      room = make Room, name: 'room'
      @chair = make Supporter, name: 'chair', enterable: true, parent: room
      out = make Room, name: 'out'
      connect room, out, 'east'
    end

    Gamefic::Plot.script do
      respond :leave, parent(@chair) do |actor, _chair|
        actor.tell "You can't leave the chair."
      end

      introduction do |actor|
        actor.parent = @chair
      end
    end
    plot = Gamefic::Plot.new
    actor = plot.introduce
    plot.ready
    chair = plot.instance_exec { @chair }
    actor.perform 'go east'
    expect(actor.parent).to eq(chair)
    expect(actor.messages).to include("You can't leave the chair.")
  end
end
