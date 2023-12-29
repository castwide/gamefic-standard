RSpec.describe 'place action' do
  it 'places a child on a supporter' do
    Gamefic.script do
      room = make Room, name: 'room'
      thing = make Thing, name: 'thing'
      supporter = make Supporter, name: 'supporter', parent: room

      introduction do |actor|
        actor.parent = room
        thing.parent = actor
      end
    end
    plot = Gamefic::Plot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'place thing supporter'
    expect(plot.entities[1].parent).to eq(plot.entities[2])
  end

  it 'takes and places an item on a supporter' do
    Gamefic.script do
      room = make Room, name: 'room'
      item = make Item, name: 'item', parent: room
      supporter = make Supporter, name: 'supporter', parent: room

      introduction do |actor|
        actor.parent = room
      end
    end
    plot = Gamefic::Plot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'place item supporter'
    expect(plot.entities[1].parent).to eq(plot.entities[2])
  end

  it 'rejects placement on non-supporters' do
    Gamefic.script do
      room = make Room, name: 'room'
      item = make Item, name: 'item'
      _thing = make Thing, name: 'thing', parent: room

      introduction do |actor|
        actor.parent = room
        item.parent = actor
      end
    end
    plot = Gamefic::Plot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'put item on thing'
    expect(plot.pick('item').parent).to be(actor)
    expect(actor.messages).to include("can't put")
  end
end
