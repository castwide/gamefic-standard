RSpec.describe 'place action' do
  it 'places a child on a supporter' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      thing = make Thing, name: 'thing'
      supporter = make Supporter, name: 'supporter', parent: room

      introduction do |actor|
        actor.parent = room
        thing.parent = actor
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'place thing supporter'
    expect(plot.entities[1].parent).to eq(plot.entities[2])
  end
end
