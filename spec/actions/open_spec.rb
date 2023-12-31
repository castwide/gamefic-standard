RSpec.describe 'Open action' do
  it 'opens with keys' do
    TestPlot.script do
      room = make Room, name: 'room'
      key = make Thing, name: 'key'
      make Container, name: 'safe', parent: room, locked: true, lock_key: key
      introduction do |actor|
        actor.parent = room
        key.parent = actor
      end
    end
    plot = TestPlot.new
    actor = plot.introduce
    plot.ready
    actor.perform 'open safe with key'
    expect(plot.pick('safe')).not_to be_locked
    expect(plot.pick('safe')).to be_open
  end
end
