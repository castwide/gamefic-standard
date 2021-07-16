RSpec.describe 'Give' do
  before :all do
    @blocks = Gamefic::Plot.blocks.dup
    require 'gamefic-standard/give'
  end

  after :all do
    Gamefic::Plot.blocks.replace @blocks
  end

  it 'responds to giving to a character' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    person = plot.make Character, name: 'person', parent: room
    player = plot.make_player_character
    plot.introduce player
    player.parent = room
    item = plot.make Item, name: 'item', parent: player
    player.perform 'give item to person'
    expect(player.messages).to include("person doesn't want")
  end

  it 'responds to giving nearby item to a character' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    person = plot.make Character, name: 'person', parent: room
    player = plot.make_player_character
    plot.introduce player
    player.parent = room
    item = plot.make Item, name: 'item', parent: room
    player.perform 'give item to person'
    expect(player.messages).to include('take the item')
    expect(player.messages).to include("person doesn't want")
  end

  it 'responds to giving to a non-character' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    person = plot.make Thing, name: 'thing', parent: room
    player = plot.make_player_character
    plot.introduce player
    player.parent = room
    item = plot.make Item, name: 'item', parent: player
    player.perform 'give item to thing'
    expect(player.messages).to include("Nothing happens")
  end
end