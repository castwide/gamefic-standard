RSpec.describe 'Quit action' do
  let(:plot) { @klass.new }

  it 'quits after confirmation' do
    actor = plot.introduce
    plot.ready
    actor.queue.push 'quit', 'yes'
    plot.update
    plot.ready
    plot.update
    plot.ready
    expect(actor).to be_concluding
  end

  it 'does not quit after cancellation' do
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
