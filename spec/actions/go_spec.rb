RSpec.describe 'Go action' do
  it 'goes through a portal' do
    plot = Gamefic::Plot.new
    plot.stage do
      room1 = make Room, name: 'room1'
      room2 = make Room, name: 'room2'
      connect room1, room2, 'east'
      introduction do |actor|
        actor.parent = room1
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'go east'
    expect(actor.parent.name).to eq('room2')
  end
end
