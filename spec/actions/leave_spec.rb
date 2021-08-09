RSpec.describe 'Leave action' do
  it 'leaves an enterable' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      klass = Class.new(Gamefic::Entity)
      klass.include Enterable
      enterable = make klass, name: 'enterable', parent: room, enterable: true
      introduction do |actor|
        actor.parent = enterable
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'leave'
    expect(actor.parent.name).to eq('room')
  end

  it 'leaves a room' do
    plot = Gamefic::Plot.new
    plot.stage do
      room1 = make Room, name: 'room 1'
      room2 = make Room, name: 'room 2'
      connect room1, room2
      introduction do |actor|
        actor.parent = room1
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'leave'
    expect(actor.parent.name).to eq('room 2')
  end

  it 'stays in parents without exits' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      thing = make Thing, name: 'thing', parent: room
      introduction do |actor|
        actor.parent = thing
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'leave'
    expect(actor.parent.name).to eq('thing')
  end

  it 'stays in rooms without exits' do
    plot = Gamefic::Plot.new
    plot.stage do
      room1 = make Room, name: 'room 1'
      make Room, name: 'room 2'
      introduction do |actor|
        actor.parent = room1
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'leave'
    expect(actor.parent.name).to eq('room 1')
  end

  it 'reports multiple ways to leave' do
    plot = Gamefic::Plot.new
    plot.stage do
      room1 = make Room, name: 'room 1'
      room2 = make Room, name: 'room 2'
      room3 = make Room, name: 'room 3'
      connect room1, room2
      connect room1, room3
      introduction do |actor|
        actor.parent = room1
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'leave'
    expect(actor.parent.name).to eq('room 1')
    expect(actor.messages).to include('room 2')
    expect(actor.messages).to include('room 3')
  end

  it 'opens entered containers' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    container = plot.make Container, name: 'container', enterable: true, open: false, parent: room
    actor = plot.make_player_character
    plot.introduce actor
    actor.parent = container
    actor.perform 'leave container'
    expect(container).to be_open
    expect(actor.parent).to be(room)
  end
end
