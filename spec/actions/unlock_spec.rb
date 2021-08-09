RSpec.describe 'Unlock action' do
  it 'reports incorrect keys' do
    plot = Gamefic::Plot.new
    room = plot.make Room
    key = plot.make Item, name: 'key'
    stick = plot.make Item, name: 'stick'
    _safe = plot.make Container, name: 'safe', lock_key: key, parent: room
    actor = plot.make_player_character
    plot.introduce actor
    actor.parent = room
    stick.parent = actor
    actor.perform 'unlock safe with stick'
    expect(actor.messages).to include("can't unlock")
  end
end
