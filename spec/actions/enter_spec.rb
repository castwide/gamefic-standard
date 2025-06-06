RSpec.describe 'Enter action' do
  let(:plot) { @klass.new }

  it 'does not enter a non-enterable thing' do
    room = plot.make Gamefic::Standard::Room
    thing = plot.make Gamefic::Standard::Receptacle, parent: room, name: 'thing', enterable: false
    actor = plot.introduce
    actor.parent = room
    actor.perform 'enter thing'
    expect(actor.parent).not_to eq(thing)
    actor.perform 'enter thing'
    expect(actor.parent).not_to eq(thing)
  end

  it 'enters an enterable thing' do
    room = plot.make Gamefic::Standard::Room
    thing = plot.make Gamefic::Standard::Receptacle, parent: room, name: 'thing', enterable: true
    thing.enterable = true
    actor = plot.introduce
    actor.parent = room
    actor.perform 'enter thing'
    expect(actor.parent).to eq(thing)
  end

  it 'stays in an enterable thing' do
    room = plot.make Gamefic::Standard::Room
    thing = plot.make Gamefic::Standard::Receptacle, parent: room, name: 'thing', enterable: true
    actor = plot.introduce
    actor.parent = thing
    actor.perform 'enter thing'
    expect(actor.parent).to eq(thing)
  end

  it 'stays in a supporter' do
    room = plot.make Gamefic::Standard::Room
    thing = plot.make Gamefic::Standard::Supporter, parent: room, name: 'thing'
    thing.enterable = true
    actor = plot.introduce
    actor.parent = thing
    actor.perform 'enter thing'
    expect(actor.parent).to eq(thing)
  end

  it 'does not enter a closed container' do
    room = plot.make Gamefic::Standard::Room
    container = plot.make Gamefic::Standard::Container, parent: room, name: 'container', enterable: true, open: false
    actor = plot.introduce
    actor.parent = room
    actor.perform 'enter container'
    expect(actor.messages).to include('closed')
    expect(actor.parent).not_to eq(container)
  end
end
