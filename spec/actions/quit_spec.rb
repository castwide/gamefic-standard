RSpec.describe 'Quit action' do
  it 'quits after confirmation' do
    plot = Gamefic::Plot.new
    actor = plot.introduce
    plot.ready
    actor.queue.push 'quit', 'yes'
    plot.ready
    plot.update
    plot.ready
    plot.update
    plot.ready
    expect(actor).to be_concluding
  end

  it 'does not quit after cancellation' do
    plot = Gamefic::Plot.new
    actor = plot.introduce
    plot.ready
    actor.queue.push 'quit', 'no'
    plot.ready
    plot.update
    plot.ready
    plot.update
    plot.ready
    expect(actor).not_to be_concluding
  end
end
