RSpec.describe 'Clothing' do
  before :all do
    @blocks = Gamefic::Plot.blocks.dup
    require 'gamefic-standard/clothing'
  end

  after :all do
    Gamefic::Plot.blocks.replace @blocks
  end

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

  it 'inventories worn clothing' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      make Shirt, name: 'shirt', parent: room

      introduction do |actor|
        actor.parent = room
        actor.perform 'put on shirt'
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'inventory'
    expect(actor.messages).to include('wearing a shirt')
  end

  it 'differentiates between carried and worn' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      make Hat, name: 'hat', parent: room
      make Shirt, name: 'shirt', parent: room

      introduction do |actor|
        actor.parent = room
        actor.perform 'take hat'
        actor.perform 'put on shirt'
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'inventory'
    expect(actor.messages).to include('carrying a hat')
    expect(actor.messages).to include('wearing a shirt')
  end

  it 'catches wearing on clothing already worn' do
    plot = Gamefic::Plot.new
    char = plot.make Character
    plot.introduce char
    plot.make Hat, name: 'hat', parent: char, attached: true
    char.perform 'wear hat'
    expect(char.messages).to include('already wearing')
  end

  it 'reports clothing not worn' do
    plot = Gamefic::Plot.new
    player = plot.make_player_character
    plot.make Hat, name: 'hat', parent: player
    plot.introduce player
    player.perform 'remove hat'
    expect(player.messages).to include('not wearing')
  end

  it 'reports empty inventory' do
    plot = Gamefic::Plot.new
    player = plot.make_player_character
    plot.introduce player
    player.perform 'inventory'
    expect(player.messages).to include("aren't carrying")
  end
end
