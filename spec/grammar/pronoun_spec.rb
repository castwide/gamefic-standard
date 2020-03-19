RSpec.describe Grammar::Pronoun do
  let(:entity) {
    entity = Object.new
    entity.extend Grammar::Attributes
    entity.gender = :neutral
    entity
  }

  it 'selects male subjective' do
    entity.gender = :male
    expect(Grammar::Pronoun.subjective(entity)).to eq('he')
  end

  it 'selects male objective' do
    entity.gender = :male
    expect(Grammar::Pronoun.objective(entity)).to eq('him')
  end

  it 'selects female subjective' do
    entity.gender = :female
    expect(Grammar::Pronoun.subjective(entity)).to eq('she')
  end

  it 'selects female objective' do
    entity.gender = :female
    expect(Grammar::Pronoun.objective(entity)).to eq('her')
  end
end
