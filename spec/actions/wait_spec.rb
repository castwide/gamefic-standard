RSpec.describe 'Wait action' do
  it 'waits' do
    plot = Gamefic::Plot.new
    actor = plot.introduce
    actor.perform 'wait'
    expect(actor.messages).to include('Time passes.')
  end
end
