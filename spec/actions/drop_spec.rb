RSpec.describe 'Drop action' do
  it 'drops held objects' do
    plot = Gamefic::Plot.new
    plot.stage do
      thing = make Thing, name: 'thing'
      introduction do |actor|
        thing.parent = actor
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'drop thing'
    expect(actor.children).to be_empty
  end

  it 'responds to objects not in inventory' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room
      make Thing, name: 'thing', parent: room
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'drop thing'
    expect(actor.messages).to include('not carrying the thing')
  end
end
