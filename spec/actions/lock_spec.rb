RSpec.describe 'Lock action' do
  it 'reports incorrect keys' do
    plot = TestPlot.new
    room = plot.make Room
    key = plot.make Item, name: 'key'
    stick = plot.make Item, name: 'stick'
    _safe = plot.make Container, name: 'safe', lock_key: key, locked: false, parent: room
    actor = plot.introduce
    actor.parent = room
    stick.parent = actor
    actor.perform 'lock safe with stick'
    expect(actor.messages).to include("can't lock")
  end
end
