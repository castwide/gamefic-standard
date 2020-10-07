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

  it 'reports items already in possession' do
    plot = Gamefic::Plot.new
    plot.stage do
      thing = make Item, name: 'thing'
      introduction do |actor|
        thing.parent = actor
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'take thing'
    expect(actor.messages).to include('already carrying')
  end

  it 'does not take non-portable entities' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room
      thing = make Thing, name: 'thing', portable: false, parent: room
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'take thing'
    expect(actor.messages).to include("can't take")
    expect(plot.pick('thing').parent).not_to be(actor)
  end

  it 'does not take attached entities' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room
      thing = make Thing, name: 'thing', parent: room
      attachment = make Item, name: 'attachment', parent: thing, attached: true
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'take attachment'
    expect(actor.messages).to include('attached')
    expect(plot.pick('attachment').parent).not_to be(actor)
  end

  it 'does not take rubble' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room
      make Rubble, name: 'rubble', parent: room
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'take rubble'
    expect(plot.pick('rubble').parent).not_to be(actor)
  end

  it 'handles unmatched text' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room
      make Item, name: 'item1', parent: room
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'take item2'
    expect(actor.messages).to include("don't see", "item2")
    expect(actor.children).to be_empty
  end
end
