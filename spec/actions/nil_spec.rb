RSpec.describe 'Nil action' do
  it 'reports unrecognized commands' do
    plot = Gamefic::Plot.new
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'unknown_command'
    expect(actor.messages).to include("I don't recognize")
  end

  it 'reports ambiguous tokens' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    item1 = plot.make Item, name: 'item 1', parent: room
    item2 = plot.make Item, name: 'item 2', parent: room
    plot.respond :foobar, Item do |actor, item|
      item.parent = actor
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.parent = room
    actor.perform 'foobar item'
    expect(actor.children).to be_empty
    expect(actor.messages).to include(item1.name)
    expect(actor.messages).to include(item2.name)
  end

  it 'reports unrecognized tokens' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    plot.make Item, name: 'item 1', parent: room
    plot.make Item, name: 'item 2', parent: room
    plot.respond :foobar, Item do |actor, item|
      item.parent = actor
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.parent = room
    actor.perform 'foobar nothing'
    expect(actor.children).to be_empty
    expect(actor.messages).to include('could not understand the rest')
  end

  it 'reports missing tokens' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    plot.make Item, name: 'item 1', parent: room
    plot.make Fixture, name: 'fixture', parent: room
    plot.respond :foobar, Item do |actor, item|
      item.parent = actor
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.parent = room
    actor.perform 'foobar'
    expect(actor.children).to be_empty
    expect(actor.messages).to include('foobar')
    expect(actor.messages).to include('could not understand')
  end

  it 'reports unhandled tokens' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    plot.make Item, name: 'item 1', parent: room
    plot.make Fixture, name: 'fixture', parent: room
    plot.respond :foobar, Item do |actor, item|
      item.parent = actor
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.parent = room
    actor.perform 'foobar fixture'
    expect(actor.children).to be_empty
    expect(actor.messages).to include('foobar')
    expect(actor.messages).to include('fixture')
  end
end
