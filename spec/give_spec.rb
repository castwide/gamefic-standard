RSpec.describe 'Give' do
  before :each do
    @klass.instance_exec do
      construct :room, Gamefic::Standard::Room, name: 'room'
      construct :person, Gamefic::Standard::Character, name: 'person', parent: room

      introduction do |player|
        player.parent = room
      end
    end
  end

  let(:plot) { @klass.new }
  let(:player) { plot.introduce }

  it 'responds to giving to a character' do
    plot.make Gamefic::Standard::Item, name: 'item', parent: player
    player.perform 'give item to person'
    expect(player.messages).to include('person has no use for')
  end

  it 'responds to giving nearby item to a character' do
    plot.make Gamefic::Standard::Item, name: 'item', parent: plot.room
    player.perform 'give item to person'
    expect(player.messages).to include('take the item')
    expect(player.messages).to include('person has no use for')
  end

  it 'responds to giving to a non-character' do
    plot.make Gamefic::Standard::Thing, name: 'thing', parent: plot.room
    plot.make Gamefic::Standard::Item, name: 'item', parent: player
    player.perform 'give item to thing'
    expect(player.messages).to include('Nothing happens')
  end

  it 'asks what' do
    plot.make Gamefic::Standard::Item, name: 'item', parent: player
    narrator = Gamefic::Narrator.new(plot)
    narrator.start
    player.queue.push 'give person'
    narrator.finish
    expect(player.messages).to include('What')
    narrator.start
    player.queue.push 'the item'
    narrator.finish
    expect(player.messages).to include('person has no use for')
  end

  it 'asks who' do
    player = plot.introduce
    player.parent = plot.room
    plot.make Gamefic::Standard::Item, name: 'item', parent: player
    narrator = Gamefic::Narrator.new(plot)
    narrator.start
    player.queue.push 'give item'
    narrator.finish
    expect(player.messages).to include('Who')
    narrator.start
    player.queue.push 'person'
    narrator.finish
    expect(player.messages).to include('person has no use for')
  end
end
