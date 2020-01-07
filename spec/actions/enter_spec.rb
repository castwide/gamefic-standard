RSpec.describe 'Enter action' do
  it 'does not enter a non-enterable thing' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    thing = plot.make Thing, parent: room, name: 'thing'
    actor = plot.get_player_character
    plot.introduce actor
    actor.parent = room
    actor.perform 'enter thing'
    expect(actor.parent).not_to be(thing)
    thing.extend Enterable
    actor.perform 'enter thing'
    expect(actor.parent).not_to be(thing)
  end

  it 'enters an enterable thing' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    thing = plot.make Thing, parent: room, name: 'thing'
    thing.extend Enterable
    thing.enterable = true
    actor = plot.get_player_character
    plot.introduce actor
    actor.parent = room
    actor.perform 'enter thing'
    expect(actor.parent).to be(thing)
  end

  it 'stays in an enterable thing' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    thing = plot.make Thing, parent: room, name: 'thing'
    thing.extend Enterable
    thing.enterable = true
    actor = plot.get_player_character
    plot.introduce actor
    actor.parent = thing
    actor.perform 'enter thing'
    expect(actor.parent).to be(thing)
  end

  it 'stays in a supporter' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    thing = plot.make Supporter, parent: room, name: 'thing'
    thing.extend Enterable
    thing.enterable = true
    actor = plot.get_player_character
    plot.introduce actor
    actor.parent = thing
    actor.perform 'enter thing'
    expect(actor.parent).to be(thing)
  end
end
