require 'gamefic'

require 'gamefic-standard/version'
require 'gamefic-standard/grammar'
require 'gamefic-standard/articles'
require 'gamefic-standard/queries'
require 'gamefic-standard/modules'
require 'gamefic-standard/direction'
require 'gamefic-standard/entities'
require 'gamefic-standard/actions'

# @todo Find a better place for this, or a better way to do it
Gamefic.script do
  introduction do |actor|
    actor.name = 'myself'
    actor.synonyms = 'self me yourself you'
  end
end
