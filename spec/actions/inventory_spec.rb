RSpec.describe 'Inventory action' do
  it 'lists children' do
    @klass.instance_exec do
      construct :held, Thing, name: 'held thing'
      construct :other, Thing, name: 'other thing'

      introduction do |actor|
        held.parent = actor
      end
    end

    plot = @klass.new
    actor = plot.introduce
    plot.ready
    actor.perform 'inventory'
    expect(actor.messages).to include('held thing')
    expect(actor.messages).not_to include('other thing')
  end

  it 'reports empty inventory' do
    plot = @klass.new
    player = plot.introduce
    player.perform 'inventory'
    expect(player.messages).to include("aren't carrying")
  end
end
