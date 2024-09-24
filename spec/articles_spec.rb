RSpec.describe Gamefic::Standard::Articles do
  let(:plot) { TestPlot.new }

  it 'attaches indefinite articles' do
    result = plot.instance_exec do
      thing = make Thing, name: 'thing'
      a thing
    end
    expect(result).to eq('a thing')
  end

  it 'attaches definite articles' do
    result = plot.instance_exec do
      thing = make Thing, name: 'thing'
      the thing
    end
    expect(result).to eq('the thing')
  end

  it 'capitalizes indefinite articles' do
    result = plot.instance_exec do
      thing = make Thing, name: 'thing'
      A thing
    end
    expect(result).to eq('A thing')
  end

  it 'capitalizes definite articles' do
    result = plot.instance_exec do
      thing = make Thing, name: 'thing'
      The thing
    end
    expect(result).to eq('The thing')
  end

  it 'ignores indefinite articles for proper names' do
    result = plot.instance_exec do
      thing = make Thing, name: 'thing', proper_named: true
      a thing
    end
    expect(result).to eq('thing')
  end

  it 'ignores definite articles for proper names' do
    result = plot.instance_exec do
      thing = make Thing, name: 'thing', proper_named: true
      the thing
    end
    expect(result).to eq('thing')
  end

  it 'capitalizes proper names without indefinite articles' do
    result = plot.instance_exec do
      thing = make Thing, name: 'thing', proper_named: true
      A thing
    end
    expect(result).to eq('Thing')
  end

  it 'capitalizes proper names without definite articles' do
    result = plot.instance_exec do
      thing = make Thing, name: 'thing', proper_named: true
      The thing
    end
    expect(result).to eq('Thing')
  end
end
