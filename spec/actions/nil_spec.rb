RSpec.describe 'Nil action' do
  it 'reports unrecognized commands' do
    plot = Gamefic::Plot.new
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'unknown_command'
    expect(actor.output).to include("I don't recognize")
  end
end
