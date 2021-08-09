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

  it 'drops things in carried receptacles' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    wallet = plot.make Receptacle, name: 'wallet', portable: true
    item = plot.make Item, name: 'item', parent: wallet
    actor = plot.get_player_character
    plot.introduce actor
    actor.parent = room
    wallet.parent = actor
    actor.perform 'drop item'
    expect(item.parent).to be(room)
  end
end
