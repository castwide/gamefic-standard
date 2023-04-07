RSpec.describe 'Wait action' do
  it 'waits' do
    plot = Gamefic::Plot.new
    actor = plot.make_player_character
    plot.introduce actor
    actor.perform 'wait'
    expect(actor.messages).to include('Time passes.')
  end
end
