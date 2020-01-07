RSpec.describe 'Quit action' do
  it 'quits after confirmation' do
    plot = Gamefic::Plot.new
    actor = plot.get_player_character
    plot.introduce actor
    actor.queue.push 'quit', 'yes'
    plot.ready
    plot.update
    plot.ready
    plot.update
    expect(actor).to be_concluded
  end

  it 'does not quit after cancellation' do
    plot = Gamefic::Plot.new
    actor = plot.get_player_character
    plot.introduce actor
    actor.queue.push 'quit', 'no'
    plot.ready
    plot.update
    plot.ready
    plot.update
    expect(actor).not_to be_concluded
  end
end
