RSpec.describe 'Repeat action' do
  let(:plot) { @klass.new }

  it 'repeats the previous action' do
    room = plot.make Room, name: 'room', description: 'room description'
    actor = plot.introduce
    narrator = Gamefic::Narrator.new(plot)
    narrator.start
    actor.parent = room
    actor.queue.push 'look'
    narrator.finish
    narrator.start
    actor.queue.push 'repeat'
    narrator.finish
    expect(actor.messages).to include("Repeating")
    # @todo We shouldn't need to go another whole round here
    narrator.start
    narrator.finish
    expect(actor.messages).to include("room description")
  end
end
