RSpec.describe 'Inventory action' do
  it 'lists children' do
    plot = Gamefic::Plot.new
    plot.stage do
      held = make Thing, name: 'held thing'
      other = make Thing, name: 'other thing'
      introduction do |actor|
        held.parent = actor
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'inventory'
    expect(actor.messages).to include('held thing')
    expect(actor.messages).not_to include('other thing')
  end

  it 'reports empty inventory' do
    plot = Gamefic::Plot.new
    player = plot.make_player_character
    plot.introduce player
    player.perform 'inventory'
    expect(player.messages).to include("aren't carrying")
  end
end
