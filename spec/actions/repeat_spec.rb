RSpec.describe 'Repeat action' do
  let(:plot) { TestPlot.new }

  it 'repeats the previous action' do
    room = plot.make Room, name: 'room', description: 'room description'
    actor = plot.introduce
    plot.ready
    actor.parent = room
    actor.queue.push 'look'
    plot.update
    plot.ready
    actor.queue.push 'repeat'
    plot.update
    expect(actor.messages).to include("Repeating")
    plot.ready
    plot.update
    expect(actor.messages).to include("room description")
  end
end
