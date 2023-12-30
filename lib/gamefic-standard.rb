require 'gamefic'

module Gamefic
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
  end
end
