# frozen_string_literal: true

require 'gamefic'
require 'gamefic-grammar'
require 'gamefic-what'

module Gamefic
  # The Gamefic standard library provides a base collection of entities and
  # rules for interactive fiction.
  #
  module Standard
    extend Gamefic::Scriptable

    require 'gamefic-standard/version'
    require 'gamefic-standard/articles'
    require 'gamefic-standard/queries'
    require 'gamefic-standard/standardized'
    require 'gamefic-standard/enterable'
    require 'gamefic-standard/openable'
    require 'gamefic-standard/lockable'
    require 'gamefic-standard/direction'
    require 'gamefic-standard/entities'
    require 'gamefic-standard/clips'
    require 'gamefic-standard/actions'
    require 'gamefic-standard/introduction'
    require 'gamefic-standard/pathfinder'

    include Articles
    include Grammar::Pronoun
    include Actions
    include Introduction

    def connect(origin, destination, direction = nil, type: Portal, two_way: true)
      origin.connect destination, direction: direction, type: type, two_way: two_way
    end
  end
end
