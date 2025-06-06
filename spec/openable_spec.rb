RSpec.describe Gamefic::Standard::Openable do
  let(:box_class) {
    box_class = Class.new(Gamefic::Standard::Thing)
    box_class.include Gamefic::Standard::Openable
    box_class
  }

  it 'opens closed objects' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    plot.make box_class, name: 'box', parent: room, open: false
    actor = plot.introduce
    actor.parent = room
    actor.perform 'open box'
    expect(plot.pick('box')).to be_open
  end

  it 'closes open objects' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    plot.make box_class, name: 'box', parent: room, open: true
    actor = plot.introduce
    actor.parent = room
    actor.perform 'close box'
    expect(plot.pick('box')).to be_closed
  end

  it 'reports open status on look' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    plot.make box_class, name: 'box', parent: room, open: true
    actor = plot.introduce
    actor.parent = room
    message = actor.quietly 'look box'
    expect(message).to include('open')
    actor.perform 'close box'
    message = actor.quietly 'look box'
    expect(message).to include('closed')
  end

  it 'reports not openable' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    plot.make Gamefic::Standard::Item, name: 'item', parent: room
    actor = plot.introduce
    actor.parent = room
    actor.perform 'open item'
    expect(actor.messages).to include("can't open")
  end

  it 'reports not closeable' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    plot.make Gamefic::Standard::Item, name: 'item', parent: room
    actor = plot.introduce
    actor.parent = room
    actor.perform 'close item'
    expect(actor.messages).to include("can't close")
  end

  it 'reports already open' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    box = plot.make box_class, name: 'box', parent: room
    box.open = true
    actor = plot.introduce
    actor.parent = room
    actor.perform 'open box'
    expect(box).to be_open
    expect(actor.messages).to include('already open')
  end

  it 'reports already closed' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room, name: 'room'
    box = plot.make box_class, name: 'box', parent: room
    box.open = false
    actor = plot.introduce
    actor.parent = room
    actor.perform 'close box'
    expect(box).to be_closed
    expect(actor.messages).to include('already closed')
  end
end
