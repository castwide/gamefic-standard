RSpec.describe 'Nil action' do
  it 'reports unrecognized commands' do
    plot = Gamefic::Plot.new
    actor = plot.make_player_character
    plot.introduce actor
    actor.perform 'unknown_command'
    expect(actor.messages).to include("I don't recognize")
  end

  it 'reports ambiguous tokens' do
    Gamefic.script do
      respond :foobar, Item do |actor, item|
        item.parent = actor
      end
    end
    plot = Gamefic::Plot.new
    room = plot.make Room
    item1 = plot.make Item, name: 'item 1', parent: room
    item2 = plot.make Item, name: 'item 2', parent: room
    actor = plot.make_player_character
    plot.introduce actor
    actor.parent = room
    actor.perform 'foobar item'
    expect(actor.children).to be_empty
    expect(actor.messages).to include(item1.name)
    expect(actor.messages).to include(item2.name)
  end

  it 'reports unrecognized tokens' do
    Gamefic.script do
      respond :foobar, Item do |actor, item|
        item.parent = actor
      end
    end
    plot = Gamefic::Plot.new
    room = plot.make Room
    plot.make Item, name: 'item 1', parent: room
    plot.make Item, name: 'item 2', parent: room
    actor = plot.make_player_character
    plot.introduce actor
    plot.ready
    actor.parent = room
    actor.perform 'foobar nothing'
    expect(actor.children).to be_empty
    expect(actor.messages).to include('recognize "foobar"')
    expect(actor.messages).to include("don't know")
  end

  it 'reports missing tokens' do
    Gamefic.script do
      respond :foobar, Item do |actor, item|
        item.parent = actor
      end
    end
    plot = Gamefic::Plot.new
    room = plot.make Room
    plot.make Item, name: 'item 1', parent: room
    plot.make Fixture, name: 'fixture', parent: room
    actor = plot.make_player_character
    plot.introduce actor
    plot.ready
    actor.parent = room
    actor.perform 'foobar'
    expect(actor.children).to be_empty
    expect(actor.messages).to include('foobar')
    expect(actor.messages).to include('could not understand')
  end

  it 'reports unhandled tokens' do
    Gamefic.script do
      respond :foobar, Item do |actor, item|
        item.parent = actor
      end
    end
    plot = Gamefic::Plot.new
    room = plot.make Room
    plot.make Item, name: 'item 1', parent: room
    plot.make Fixture, name: 'fixture', parent: room
    actor = plot.make_player_character
    plot.introduce actor
    plot.ready
    actor.parent = room
    actor.perform 'foobar fixture'
    expect(actor.children).to be_empty
    expect(actor.messages).to include('foobar')
    expect(actor.messages).to include('fixture')
  end

  it 'reports recognized verbs with mismatched tokens' do
    Gamefic.script do
      room = make Room, name: 'room'
      make Thing, name: 'thing', parent: room
      make Thing, name: 'other', parent: room

      respond :affix, available(Thing), available(Item) do |actor, _, _|
        actor.tell "Should not happen"
      end
      # Test with synonym instead of action verb
      interpret "glue :thing to :other", "affix :thing :other"

      introduction do |actor|
        actor.parent = room
      end
    end
    plot = Gamefic::Plot.new
    actor = plot.make_player_character
    plot.introduce actor
    plot.ready
    actor.perform 'glue thing to other'
    expect(actor.messages).to include('I recognize "glue" as a verb')
  end
end
