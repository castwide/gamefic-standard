RSpec.describe 'Inventory action' do
  it 'lists children' do
    TestPlot.seed do
      @held = make Thing, name: 'held thing'
      @other = make Thing, name: 'other thing'
    end
    TestPlot.script do
      introduction do |actor|
        @held.parent = actor
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'inventory'
    expect(actor.messages).to include('held thing')
    expect(actor.messages).not_to include('other thing')
  end

  it 'reports empty inventory' do
    plot = TestPlot.new
    player = plot.introduce
    player.perform 'inventory'
    expect(player.messages).to include("aren't carrying")
  end
end
