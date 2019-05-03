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
end
