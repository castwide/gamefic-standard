require 'gamefic-standard/clothing'

RSpec.describe Clothing do
  it 'can be worn' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      make Shirt, name: 'shirt', parent: room

      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'put on shirt'
    shirt = plot.pick('shirt')
    expect(shirt.parent).to be(actor)
    expect(shirt).to be_worn
  end

  it 'can be removed' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      shirt = make Shirt, name: 'shirt', parent: room

      introduction do |actor|
        actor.parent = room
        actor.perform 'put on shirt'
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'take off shirt'
    shirt = plot.pick('shirt')
    expect(shirt.parent).to be(actor)
    expect(shirt).not_to be_worn
  end

  it 'gets removed when dropped' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      shirt = make Shirt, name: 'shirt', parent: room

      introduction do |actor|
        actor.parent = room
        actor.perform 'put on shirt'
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'drop shirt'
    shirt = plot.pick('shirt')
    expect(shirt.parent).not_to be(actor)
    expect(shirt).not_to be_worn
  end

  it 'detects types of clothing already worn' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      shirt = make Shirt, name: 'shirt', parent: room
      blouse = make Shirt, name: 'blouse', parent: room

      introduction do |actor|
        actor.parent = room
        actor.perform 'put on shirt'
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'put on blouse'
    shirt = plot.pick('shirt')
    expect(shirt.parent).to be(actor)
    expect(shirt).to be_worn
    blouse = plot.pick('blouse')
    expect(blouse.parent).to be(actor)
    expect(blouse).not_to be_worn
  end
end
