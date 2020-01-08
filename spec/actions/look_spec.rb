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
    actor.perform "look thing"
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
    actor.perform "look"
    expect(actor.messages).to include(plot.pick('room').description)
    expect(actor.messages).to include('thing')
  end

  # it 'looks at itself' do
  #   plot = Gamefic::Plot.new
  #   actor = plot.get_player_character
  #   actor.description = 'my description'
  #   actor.perform "look self"
  #   expect(actor.messages).to include(actor.description)
  # end
end
