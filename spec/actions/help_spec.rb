RSpec.describe 'Help action' do
  let(:plot) { Gamefic::Plot.new }

  let(:player) do
    player = plot.introduce
    player
  end

  it 'displays a list of commands' do
    player.perform 'help'
    plot.rulebook.synonyms.each do |syn|
      expect(player.messages).to include(syn.to_s)
    end
  end

  it 'displays command details' do
    plot.rulebook.synonyms.each do |syn|
      player.perform "help #{syn}"
      expect(player.messages).to include('Examples:')
      player.flush
    end
  end
end
