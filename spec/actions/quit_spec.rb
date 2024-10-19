RSpec.describe 'Quit action' do
  let(:plot) { @klass.new }

  it 'quits after confirmation' do
    actor = plot.introduce
    narrator = Gamefic::Narrator.new(plot)
    narrator.start
    actor.queue.push 'quit', 'yes'
    narrator.finish
    narrator.start
    narrator.finish
    narrator.start
    expect(actor).to be_concluding
  end

  it 'does not quit after cancellation' do
    actor = plot.introduce
    narrator = Gamefic::Narrator.new(plot)
    narrator.start
    actor.queue.push 'quit', 'no'
    narrator.finish
    narrator.start
    narrator.finish
    narrator.start
    expect(actor).not_to be_concluding
  end
end
