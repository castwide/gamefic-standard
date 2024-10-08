RSpec.describe 'Give' do
  let(:klass) { TestPlot }

  let(:plot) { klass.new }

  it 'responds to giving to a character' do
    room = plot.make Room
    person = plot.make Character, name: 'person', parent: room
    player = plot.introduce
    player.parent = room
    item = plot.make Item, name: 'item', parent: player
    player.perform 'give item to person'
    expect(player.messages).to include("person has no use for")
  end

  it 'responds to giving nearby item to a character' do
    room = plot.make Room
    person = plot.make Character, name: 'person', parent: room
    player = plot.introduce
    player.parent = room
    item = plot.make Item, name: 'item', parent: room
    player.perform 'give item to person'
    expect(player.messages).to include('take the item')
    expect(player.messages).to include("person has no use for")
  end

  it 'responds to giving to a non-character' do
    room = plot.make Room
    person = plot.make Thing, name: 'thing', parent: room
    player = plot.introduce
    player.parent = room
    item = plot.make Item, name: 'item', parent: player
    player.perform 'give item to thing'
    expect(player.messages).to include("Nothing happens")
  end

  it 'asks what' do
    room = plot.make Room
    person = plot.make Character, name: 'person', parent: room
    player = plot.introduce
    player.parent = room
    item = plot.make Item, name: 'item', parent: player
    plot.ready
    player.queue.push 'give person'
    plot.update
    expect(player.messages).to include('What')
    plot.ready
    player.queue.push 'the item'
    plot.update
    expect(player.messages).to include("person has no use for")
  end

  it 'asks who' do
    room = plot.make Room
    person = plot.make Character, name: 'person', parent: room
    player = plot.introduce
    player.parent = room
    item = plot.make Item, name: 'item', parent: player
    plot.ready
    player.queue.push 'give item'
    plot.update
    expect(player.messages).to include('Who')
    plot.ready
    player.queue.push 'person'
    plot.update
    expect(player.messages).to include("person has no use for")
  end
end
