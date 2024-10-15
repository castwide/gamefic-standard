RSpec.describe 'Give' do
  let(:plot) { @klass.new }

  let(:player) { plot.introduce }

  before :each do
    @klass.instance_exec do
      bind_make :room, Room, name: 'room'
      bind_make :person, Character, name: 'person', parent: room

      introduction do |player|
        player.parent = room
      end
    end
  end

  it 'responds to giving to a character' do
    plot.make Item, name: 'item', parent: player
    player.perform 'give item to person'
    expect(player.messages).to include('person has no use for')
  end

  it 'responds to giving nearby item to a character' do
    plot.make Item, name: 'item', parent: plot.room
    player.perform 'give item to person'
    expect(player.messages).to include('take the item')
    expect(player.messages).to include('person has no use for')
  end

  it 'responds to giving to a non-character' do
    plot.make Thing, name: 'thing', parent: plot.room
    plot.make Item, name: 'item', parent: player
    player.perform 'give item to thing'
    expect(player.messages).to include('Nothing happens')
  end

  it 'asks what' do
    plot.make Item, name: 'item', parent: player
    plot.ready
    player.queue.push 'give person'
    plot.update
    expect(player.messages).to include('What')
    plot.ready
    player.queue.push 'the item'
    plot.update
    expect(player.messages).to include('person has no use for')
  end

  it 'asks who' do
    room = plot.make Room
    person = plot.make Character, name: 'person', parent: plot.room
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
    expect(player.messages).to include('person has no use for')
  end
end
