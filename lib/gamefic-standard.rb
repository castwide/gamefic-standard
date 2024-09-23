# frozen_string_literal: true

require 'gamefic'
require 'gamefic-what'

module Gamefic
  # The Gamefic standard library provides a base collection of entities and
  # rules for interactive fiction.
  #
  module Standard
    extend Gamefic::Scriptable

    require 'gamefic-standard/version'
    require 'gamefic-standard/grammar'
    require 'gamefic-standard/articles'
    require 'gamefic-standard/queries'
    require 'gamefic-standard/modules'
    require 'gamefic-standard/direction'
    require 'gamefic-standard/entities'
    require 'gamefic-standard/actions'
    require 'gamefic-standard/introduction'
    require 'gamefic-standard/give'

    include Nil
    include Articles
    include Grammar::Pronoun
    include Give
    include Gamefic::What

    def connect(origin, destination, direction = nil, type: Portal, two_way: true)
      origin.connect destination, direction: direction, type: type, two_way: two_way
    end
  end
end
