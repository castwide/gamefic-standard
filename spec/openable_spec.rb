RSpec.describe Openable do
  it 'opens closed objects' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      box_class = Class.new(Thing)
      box_class.include Openable
      make box_class, name: 'box', parent: room, open: false
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'open box'
    expect(plot.pick('box')).to be_open
  end

  it 'closes open objects' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      box_class = Class.new(Thing)
      box_class.include Openable
      make box_class, name: 'box', parent: room, open: true
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'close box'
    expect(plot.pick('box')).to be_closed
  end

  it 'reports open status on look' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      box_class = Class.new(Thing)
      box_class.include Openable
      make box_class, name: 'box', parent: room, open: true
      introduction do |actor|
        actor.parent = room
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    message = actor.quietly 'look box'
    expect(message).to include('open')
    actor.perform 'close box'
    message = actor.quietly 'look box'
    expect(message).to include('closed')
  end
end
