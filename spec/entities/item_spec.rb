RSpec.describe Gamefic::Standard::Item do
  it 'is portable by default' do
    item = Gamefic::Standard::Item.new
    expect(item).to be_portable
  end
end
