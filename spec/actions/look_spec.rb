RSpec.describe 'Look action' do
  it 'returns a sibling description' do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room, name: 'room'
      construct :thing, Gamefic::Standard::Thing, name: 'thing', description: 'This is a thing', parent: room

      introduction do |actor|
        actor.parent = room
      end
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'look thing'
    expect(actor.messages).to include(plot.pick('thing').description)
  end

  it 'returns a room description' do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room, name: 'room', description: 'your area'
      construct :thing, Gamefic::Standard::Thing, name: 'thing', description: 'a thing', parent: room

      introduction do |actor|
        actor.parent = room
      end
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'look'
    expect(actor.messages).to include(plot.pick('room').description)
    expect(actor.messages).to include('thing')
  end

  it 'looks at itself' do
    plot = @klass.new
    actor = plot.introduce
    actor.synonyms = 'self'
    actor.description = 'my description'
    actor.perform 'look self'
    expect(actor.messages).to include(actor.description)
  end

  it 'looks at room without arguments' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room', description: 'the room description'
    actor = plot.introduce
    actor.parent = room
    actor.perform 'look'
    expect(actor.messages).to include(room.description)
  end

  it 'looks around' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room', description: 'the room description'
    actor = plot.introduce
    actor.parent = room
    actor.perform 'look around'
    expect(actor.messages).to include(room.description)
  end

  it 'sees attachments' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room', description: 'the room description'
    thing = plot.make Gamefic::Standard::Thing, name: 'thing', parent: room
    attachment = plot.make Gamefic::Standard::Thing, parent: thing, name: 'attachment', attached: true
    actor = plot.introduce
    actor.parent = room
    actor.perform 'look thing'
    expect(actor.messages).to include(attachment.name)
  end

  it 'sees accessible supported entities' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room', description: 'the room description'
    supporter = plot.make Gamefic::Standard::Supporter, name: 'supporter', parent: room
    plot.make Gamefic::Standard::Thing, parent: supporter, name: 'thing'
    actor = plot.introduce
    actor.parent = room
    actor.perform 'look supporter'
    expect(actor.messages).to include('thing')
  end

  it 'sees supported entities' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    supporter = plot.make Gamefic::Standard::Supporter, name: 'supporter', parent: room
    thing = plot.make Gamefic::Standard::Thing, parent: supporter, name: 'thing'
    actor = plot.introduce
    actor.parent = room
    actor.perform 'look supporter'
    expect(actor.messages).to include(thing.name)
  end

  it 'sees receptacled entities' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    receptacle = plot.make Gamefic::Standard::Receptacle, name: 'receptacle', parent: room
    thing = plot.make Gamefic::Standard::Thing, parent: receptacle, name: 'thing'
    actor = plot.introduce
    actor.parent = room
    actor.perform 'look receptacle'
    expect(actor.messages).to include(thing.name)
  end

  it 'sees locale descriptions' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    thing = plot.make Gamefic::Standard::Thing, name: 'thing', parent: room, locale_description: 'The long description of the thing'
    actor = plot.introduce
    actor.parent = room
    actor.perform 'look'
    expect(actor.messages).to include(thing.locale_description)
  end

  it 'catches unrecognized objects' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    thing = plot.make Gamefic::Standard::Thing, name: 'thing', parent: room, description: 'The thing'
    actor = plot.introduce
    actor.parent = room
    actor.perform 'look doodad'
    expect(actor.messages).not_to include(thing.description)
    expect(actor.messages).to include("don't know")
    expect(actor.messages).to include('doodad')
  end

  it 'reports being on a supporter' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    supporter = plot.make Gamefic::Standard::Supporter, name: 'supporter', enterable: true, parent: room
    actor = plot.introduce
    actor.put supporter, :on
    actor.perform 'look supporter'
    expect(actor.messages).to include('currently on the supporter')
    actor.flush
    actor.perform 'look'
    expect(actor.messages).to include('on top of the supporter')
  end

  it 'sees characters' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    _character = plot.make Gamefic::Standard::Character, name: 'character', parent: room
    actor = plot.introduce
    actor.parent = room
    actor.perform 'look'
    expect(actor.messages).to include('character is here')
    plot.make Gamefic::Standard::Character, name: 'extra', parent: room
    actor.perform 'look'
    expect(actor.messages).to include('are here')
  end

  it 'sees character locale descriptions' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    character = plot.make Gamefic::Standard::Character, name: 'thing', locale_description: 'A character is present.', parent: room
    actor = plot.introduce
    actor.parent = room
    actor.perform 'look'
    expect(actor.messages).to include(character.locale_description)
  end

  it 'sees multiple exits' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    room.connect nil, direction: 'north', two_way: false
    room.connect nil, direction: 'south', two_way: false
    actor = plot.introduce
    actor.parent = room
    actor.perform 'look'
    expect(actor.messages).to include('exits north and south')
  end

  it 'sees other objects on supporters' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    supporter = plot.make Gamefic::Standard::Supporter, name: 'supporter', parent: room
    plot.make Gamefic::Standard::Thing, name: 'thing', parent: supporter
    actor = plot.introduce
    actor.parent = supporter
    actor.perform 'look'
    expect(actor.messages).to include('thing')
    actor.flush
    actor.perform 'look supporter'
    expect(actor.messages).to include('thing')
  end
end
