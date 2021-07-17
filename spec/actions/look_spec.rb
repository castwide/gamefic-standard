RSpec.describe 'Look action' do
  it 'returns a sibling description' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      thing = make Thing, name: 'thing', description: 'This is a thing', parent: room
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'look thing'
    expect(actor.messages).to include(plot.pick('thing').description)
  end

  it 'returns a room description' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room', description: 'your area'
      thing = make Thing, name: 'thing', description: 'a thing', parent: room
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'look'
    expect(actor.messages).to include(plot.pick('room').description)
    expect(actor.messages).to include('thing')
  end

  it 'looks at itself' do
    plot = Gamefic::Plot.new
    actor = plot.get_player_character
    actor.synonyms = 'self'
    actor.description = 'my description'
    actor.perform 'look self'
    expect(actor.messages).to include(actor.description)
  end

  it 'looks at room without arguments' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room', description: 'the room description'
    actor = plot.get_player_character
    actor.parent = room
    actor.perform 'look'
    expect(actor.messages).to include(room.description)
  end

  it 'looks around' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room', description: 'the room description'
    actor = plot.get_player_character
    actor.parent = room
    actor.perform 'look around'
    expect(actor.messages).to include(room.description)
  end

  it 'sees attachments' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room', description: 'the room description'
    thing = plot.make Thing, name: 'thing', parent: room
    attachment = plot.make Thing, parent: thing, name: 'attachment', attached: true
    actor = plot.get_player_character
    actor.parent = room
    actor.perform 'look thing'
    expect(actor.messages).to include(attachment.name)
  end

  it 'sees accessible supported entities' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room', description: 'the room description'
    supporter = plot.make Supporter, name: 'supporter', parent: room
    thing = plot.make Thing, parent: supporter, name: 'thing'
    actor = plot.get_player_character
    actor.parent = room
    actor.perform 'look supporter'
    expect(actor.messages).to include('thing')
  end

  it 'sees supported entities' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room'
    supporter = plot.make Supporter, name: 'supporter', parent: room
    thing = plot.make Thing, parent: supporter, name: 'thing'
    actor = plot.get_player_character
    actor.parent = room
    actor.perform 'look supporter'
    expect(actor.messages).to include(thing.name)
  end

  it 'sees receptacled entities' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room'
    receptacle = plot.make Receptacle, name: 'receptacle', parent: room
    thing = plot.make Thing, parent: receptacle, name: 'thing'
    actor = plot.get_player_character
    actor.parent = room
    actor.perform 'look receptacle'
    expect(actor.messages).to include(thing.name)
  end

  it 'sees locale descriptions' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room'
    thing = plot.make Thing, name: 'thing', parent: room, locale_description: 'The long description of the thing'
    actor = plot.get_player_character
    actor.parent = room
    actor.perform 'look'
    expect(actor.messages).to include(thing.locale_description)
  end

  it 'catches unrecognized objects' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room'
    thing = plot.make Thing, name: 'thing', parent: room, description: 'The thing'
    actor = plot.get_player_character
    actor.parent = room
    actor.perform 'look doodad'
    expect(actor.messages).not_to include(thing.description)
    expect(actor.messages).to include("don't know")
    expect(actor.messages).to include('doodad')
  end

  it 'reports being on a supporter' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room'
    supporter = plot.make Supporter, name: 'supporter', enterable: true, parent: room
    actor = plot.make_player_character
    plot.introduce actor
    actor.parent = supporter
    actor.perform 'look supporter'
    expect(actor.messages).to include('currently on the supporter')
    actor.messages.clear
    actor.perform 'look'
    expect(actor.messages).to include('on the supporter')
  end

  it 'sees characters' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room'
    _character = plot.make Character, name: 'character', parent: room
    actor = plot.make_player_character
    plot.introduce actor
    actor.parent = room
    actor.perform 'look'
    expect(actor.messages).to include('character is here')
    plot.make Character, name: 'extra', parent: room
    actor.perform 'look'
    expect(actor.messages).to include('are here')
  end

  it 'sees character locale descriptions' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room'
    character = plot.make Character, name: 'thing', locale_description: 'A character is present.', parent: room
    actor = plot.make_player_character
    plot.introduce actor
    actor.parent = room
    actor.perform 'look'
    expect(actor.messages).to include(character.locale_description)
  end

  it 'sees multiple exits' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room'
    plot.connect room, nil, 'north', two_way: false
    plot.connect room, nil, 'south', two_way: false
    actor = plot.make_player_character
    plot.introduce actor
    actor.parent = room
    actor.perform 'look'
    expect(actor.messages).to include('exits north and south')
  end
end
