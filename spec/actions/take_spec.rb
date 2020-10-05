RSpec.describe 'Take action' do
  it 'takes items' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room
      thing = make Item, name: 'item', parent: room
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'take item'
    expect(actor.children.first.name).to eq('item')
  end

  it 'takes items from receptacles implicitly' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room
      receptacle = make Receptacle, name: 'receptacle', parent: room
      make Item, name: 'item', parent: receptacle
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'take item'
    expect(actor.children.first.name).to eq('item')
  end

  it 'takes items from receptacles explicitly' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room
      receptacle = make Receptacle, name: 'receptacle', parent: room
      make Item, name: 'item', parent: receptacle
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'take item from receptacle'
    expect(actor.children.first.name).to eq('item')
  end
end
