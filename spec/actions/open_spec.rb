RSpec.describe 'Open action' do
  it 'opens with keys' do
    @klass.instance_exec do
      construct :room, Room, name: 'room'
      construct :key, Thing, name: 'key'
      construct :container, Container, name: 'safe', parent: room, locked: true, lock_key: key

      introduction do |actor|
        actor.parent = room
        key.parent = actor
      end
    end

    plot = @klass.new
    actor = plot.introduce
    actor.perform 'open safe with key'
    expect(plot.pick('safe')).not_to be_locked
    expect(plot.pick('safe')).to be_open
  end
end
