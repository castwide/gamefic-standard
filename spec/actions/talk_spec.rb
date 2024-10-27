RSpec.describe 'Talk action' do
  let(:plot) { @klass.new }

  it 'talks to self' do
    player = plot.introduce
    player.perform 'talk'
    expect(player.messages).to include('You talk to yourself')
    player.flush
    player.perform 'talk self'
    expect(player.messages).to include('You talk to yourself')
  end

  it 'talks to thing' do
    room = plot.make Gamefic::Standard::Room
    plot.make Gamefic::Standard::Thing, name: 'thing', parent: room
    player = plot.introduce
    player.parent = room
    player.perform 'talk to thing'
    expect(player.messages).to include('Nothing happens')
  end

  it 'talks to character' do
    room = plot.make Gamefic::Standard::Room
    plot.make Gamefic::Standard::Character, name: 'character', parent: room
    player = plot.introduce
    player.parent = room
    player.perform 'talk to character'
    expect(player.messages).to include('has nothing to say')
  end
end
