RSpec.describe Gamefic::Standard::Grammar::Pronoun do
  let(:entity) {
    entity = Object.new
    entity.extend Gamefic::Standard::Grammar::Attributes
    entity.gender = :neutral
    entity
  }

  it 'selects male subjective' do
    entity.gender = :male
    expect(Gamefic::Standard::Grammar::Pronoun.subjective(entity)).to eq('he')
  end

  it 'selects male objective' do
    entity.gender = :male
    expect(Gamefic::Standard::Grammar::Pronoun.objective(entity)).to eq('him')
  end

  it 'selects female subjective' do
    entity.gender = :female
    expect(Gamefic::Standard::Grammar::Pronoun.subjective(entity)).to eq('she')
  end

  it 'selects female objective' do
    entity.gender = :female
    expect(Gamefic::Standard::Grammar::Pronoun.objective(entity)).to eq('her')
  end

  it 'selects male possessive' do
    entity.gender = :male
    expect(Gamefic::Standard::Grammar::Pronoun.possessive(entity)).to eq('his')
  end

  it 'selects female possessive' do
    entity.gender = :female
    expect(Gamefic::Standard::Grammar::Pronoun.possessive(entity)).to eq('her')
  end

  it 'selects male reflexive' do
    entity.gender = :male
    expect(Gamefic::Standard::Grammar::Pronoun.reflexive(entity)).to eq('himself')
  end

  it 'selects female reflexive' do
    entity.gender = :female
    expect(Gamefic::Standard::Grammar::Pronoun.reflexive(entity)).to eq('herself')
  end
end
