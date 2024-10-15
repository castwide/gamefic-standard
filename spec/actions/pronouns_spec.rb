# frozen_string_literal: true

RSpec.describe 'pronouns' do
  let(:plot) {
    @klass.seed do
      @room = make Room, name: 'room', description: 'room description'
    end

    @klass.script do
      introduction do |actor|
        actor.parent = @room
      end
    end

    @klass.new
  }

  let(:room) { plot.pick('room') }

  let(:player) { plot.introduce }

  it 'understands it' do
    item = plot.make(Item, name: 'item', parent: room, description: 'item description')
    player.perform 'look item'
    expect(player.messages).to include('item description')
    player.perform 'take it'
    expect(item.parent).to be(player)
    player.perform 'drop it'
    expect(item.parent).to be(room)
  end

  it 'understands him' do
    plot.make(Character, name: 'man', parent: room, description: 'man description', gender: :male)
    player.perform 'look man'
    expect(player.messages).to include('man description')
    player.perform 'talk to him'
    expect(player.messages).to include('nothing to say')
    player.flush
    player.perform 'look at him'
    expect(player.messages).to include('man description')
  end

  it 'understands her' do
    plot.make(Character, name: 'woman', parent: room, description: 'woman description', gender: :female)
    player.perform 'look woman'
    expect(player.messages).to include('woman description')
    player.perform 'talk to her'
    expect(player.messages).to include('nothing to say')
    player.flush
    player.perform 'look at her'
    expect(player.messages).to include('woman description')
  end

  it 'understands them' do
    plot.make(Character, name: 'person', parent: room, description: 'person description', gender: :other)
    player.perform 'look person'
    expect(player.messages).to include('person description')
    player.perform 'talk to them'
    expect(player.messages).to include('nothing to say')
    player.flush
    player.perform 'look at them'
    expect(player.messages).to include('person description')
  end
end