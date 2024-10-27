RSpec.describe 'Nil action' do
  let(:plot) { @klass.new }

  it 'reports unrecognized commands' do
    actor = plot.introduce
    actor.perform 'unknown_command'
    expect(actor.messages).to include("I don't recognize")
  end

  it 'reports ambiguous tokens' do
    @klass.instance_exec do
      respond :foobar, Gamefic::Standard::Item do |actor, item|
        item.parent = actor
      end
    end
    room = plot.make Gamefic::Standard::Room
    item1 = plot.make Gamefic::Standard::Item, name: 'item 1', parent: room
    item2 = plot.make Gamefic::Standard::Item, name: 'item 2', parent: room
    actor = plot.introduce
    actor.parent = room
    actor.perform 'foobar item'
    expect(actor.children).to be_empty
    expect(actor.messages).to include(item1.name)
    expect(actor.messages).to include(item2.name)
  end

  it 'reports unrecognized tokens' do
    @klass.instance_exec do
      respond :foobar, Gamefic::Standard::Item do |actor, item|
        item.parent = actor
      end
    end
    room = plot.make Gamefic::Standard::Room
    plot.make Gamefic::Standard::Item, name: 'item 1', parent: room
    plot.make Gamefic::Standard::Item, name: 'item 2', parent: room
    actor = plot.introduce
    actor.parent = room
    actor.perform 'foobar nothing'
    expect(actor.children).to be_empty
    expect(actor.messages).to include('recognize "foobar"')
    expect(actor.messages).to include("don't know")
  end

  it 'reports missing tokens' do
    @klass.instance_exec do
      respond :foobar, Gamefic::Standard::Item do |actor, item|
        item.parent = actor
      end
    end
    room = plot.make Gamefic::Standard::Room
    plot.make Gamefic::Standard::Item, name: 'item 1', parent: room
    plot.make Gamefic::Standard::Fixture, name: 'fixture', parent: room
    actor = plot.introduce
    actor.parent = room
    actor.perform 'foobar'
    expect(actor.children).to be_empty
    expect(actor.messages).to include('foobar')
    expect(actor.messages).to include('could not understand')
  end

  it 'reports unhandled tokens' do
    @klass.instance_exec do
      respond :foobar, Gamefic::Standard::Item do |actor, item|
        item.parent = actor
      end
    end
    room = plot.make Gamefic::Standard::Room
    plot.make Gamefic::Standard::Item, name: 'item 1', parent: room
    plot.make Gamefic::Standard::Fixture, name: 'fixture', parent: room
    actor = plot.introduce
    actor.parent = room
    actor.perform 'foobar fixture'
    expect(actor.children).to be_empty
    expect(actor.messages).to include('foobar')
    expect(actor.messages).to include('fixture')
  end

  it 'reports recognized verbs with mismatched tokens' do
    @klass.instance_exec do
      bind_make :room, Gamefic::Standard::Room, name: 'room'
      seed do
        make Gamefic::Standard::Thing, name: 'thing', parent: room
        make Gamefic::Standard::Thing, name: 'other', parent: room
      end

      respond :affix, available(Gamefic::Standard::Thing), available(Gamefic::Standard::Item) do |actor, _, _|
        actor.tell "Should not happen"
      end

      # Test with synonym instead of action verb
      interpret "glue :thing to :other", "affix :thing :other"

      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.introduce
    actor.perform 'glue thing to other'
    expect(actor.messages).to include('I recognize "glue thing" as a command')
  end

  it 'ignores empty commands' do
    actor = plot.introduce
    actor.perform ''
    expect(actor.messages).to be_empty
  end
end
