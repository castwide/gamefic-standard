RSpec.describe 'place action' do
  it 'places a child on a supporter' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      thing = make Thing, name: 'thing'
      supporter = make Supporter, name: 'supporter', parent: room

      introduction do |actor|
        actor.parent = room
        thing.parent = actor
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'place thing supporter'
    expect(plot.entities[1].parent).to eq(plot.entities[2])
  end

  it 'takes and places an item on a supporter' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      item = make Item, name: 'item', parent: room
      supporter = make Supporter, name: 'supporter', parent: room

      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'place item supporter'
    expect(plot.entities[1].parent).to eq(plot.entities[2])
  end

  it 'rejects placement on non-supporters' do
    plot = Gamefic::Plot.new
    room = plot.make Room, name: 'room'
    item = plot.make Item, name: 'item'
    _thing = plot.make Thing, name: 'thing', parent: room

    plot.introduction do |actor|
      actor.parent = room
      item.parent = actor
    end

    actor = plot.make_player_character
    plot.introduce actor
    actor.perform 'put item on thing'
    expect(item.parent).to be(actor)
    expect(actor.messages).to include("can't put")
  end
end
