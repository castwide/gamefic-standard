RSpec.describe Item do
  it 'is portable by default' do
    item = Item.new
    expect(item).to be_portable
  end
end
