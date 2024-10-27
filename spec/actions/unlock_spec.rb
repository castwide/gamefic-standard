RSpec.describe 'Unlock action' do
  it 'reports incorrect keys' do
    plot = @klass.new
    room = plot.make Gamefic::Standard::Room
    key = plot.make Gamefic::Standard::Item, name: 'key'
    stick = plot.make Gamefic::Standard::Item, name: 'stick'
    _safe = plot.make Gamefic::Standard::Container, name: 'safe', lock_key: key, parent: room
    actor = plot.introduce
    actor.parent = room
    stick.parent = actor
    actor.perform 'unlock safe with stick'
    expect(actor.messages).to include("can't unlock")
  end
end
