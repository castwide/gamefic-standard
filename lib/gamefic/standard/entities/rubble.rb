# frozen_string_literal: true

require 'gamefic/standard/entities/scenery'

module Gamefic
  module Standard
    # Rubble is Scenery with slightly modified action responses.
    # Intended for things that might be portable but are useless.
    # Rule of thumb: Scenery is something that can't be carried,
    # like a table or the sky; and Rubble is something that might
    # be portable but is otherwise useless, like trash or debris.
    #
    class Rubble < Scenery
    end
  end
end
