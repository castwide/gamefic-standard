RSpec.describe 'Open action' do
  it 'opens with keys' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      key = make Thing, name: 'key'
      safe_class = Class.new(Thing)
      safe_class.include Lockable
      make safe_class, name: 'safe', parent: room, locked: true, lock_key: key
      introduction do |actor|
        actor.parent = room
        key.parent = actor
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'open safe with key'
    expect(plot.pick('safe')).not_to be_locked
    expect(plot.pick('safe')).to be_open
  end
end
