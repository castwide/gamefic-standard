RSpec.describe 'Inventory action' do
  it 'lists children' do
    Gamefic::Plot.script do
      held = make Thing, name: 'held thing'
      other = make Thing, name: 'other thing'
      introduction do |actor|
        held.parent = actor
      end
    end
    plot = Gamefic::Plot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'inventory'
    expect(actor.messages).to include('held thing')
    expect(actor.messages).not_to include('other thing')
  end

  it 'reports empty inventory' do
    plot = Gamefic::Plot.new
    player = plot.introduce
    player.perform 'inventory'
    expect(player.messages).to include("aren't carrying")
  end
end
