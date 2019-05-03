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
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform "look"
    expect(actor.messages).to include(plot.pick('room').description)
  end
end
