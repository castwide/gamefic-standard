# frozen_string_literal: true

require 'gamefic-standard/test'

RSpec.describe 'test' do
  it 'queues commands' do
    Gamefic::Plot.script do
      on_test :me do |_actor, queue|
        queue.concat ['first', 'second']
      end
    end
    plot = Gamefic::Plot.new
    player = plot.introduce
    player.perform 'test me'
    expect(player.queue).to eq(['first', 'second'])
  end

  it 'reports unknown tests' do
    plot = Gamefic::Plot.new
    player = plot.introduce
    player.perform 'test them'
    expect(player.queue).to be_empty
    expect(player.messages).to include('no test named "them"')
  end

  it 'serializes' do
    Gamefic::Plot.script do
      on_test :me do |_actor, queue|
        queue.concat ['first', 'second']
      end
    end
    plot = Gamefic::Plot.new
    player = plot.introduce
    plot.ready
    player.perform 'test me'
    expect {
      snapshot = plot.save
      Gamefic::Snapshot.restore snapshot
    }.not_to raise_error
  end
end
