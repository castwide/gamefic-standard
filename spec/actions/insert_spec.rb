require 'gamefic-standard/container'

RSpec.describe 'insert action' do
  it 'inserts a child in a receptacle' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      thing = make Thing, name: 'thing'
      receptacle = make Receptacle, name: 'receptacle', parent: room

      introduction do |actor|
        actor.parent = room
        thing.parent = actor
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'insert thing receptacle'
    expect(plot.entities[1].parent).to eq(plot.entities[2])
  end

  it 'inserts a child in an open container' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      thing = make Thing, name: 'thing'
      container = make Container, name: 'container', parent: room, open: true

      introduction do |actor|
        actor.parent = room
        thing.parent = actor
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'insert thing container'
    expect(plot.entities[1].parent).to eq(plot.entities[2])
  end

  it 'does not insert a child in a closed container' do
    plot = Gamefic::Plot.new
    plot.stage do
      room = make Room, name: 'room'
      thing = make Thing, name: 'thing'
      container = make Container, name: 'container', parent: room, open: false

      introduction do |actor|
        actor.parent = room
        thing.parent = actor
      end
    end
    actor = plot.get_player_character
    plot.introduce actor
    actor.perform 'insert thing container'
    expect(plot.entities[1].parent).not_to eq(plot.entities[2])
  end
end
