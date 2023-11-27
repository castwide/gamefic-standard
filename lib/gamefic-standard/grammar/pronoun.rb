# frozen_string_literal: true

module Grammar
  # Functions to select pronouns based on an entity's attributes, such as
  # gender.
  #
  module Pronoun
    extend self

    # @param entity [#person, #plural?, #gender]
    # @return [String]
    def subjective(entity)
      map(entity)[:subjective]
    end
    alias they subjective
    alias he subjective
    alias she subjective

    # @param entity [#person, #plural?, #gender]
    # @return [String]
    def subjective_(entity)
      subjective(entity).cap_first
    end
    alias they_ subjective_
    alias he_ subjective_
    alias she_ subjective_

    # @param entity [#person, #plural?, #gender]
    # @return [String]
    def objective(entity)
      map(entity)[:objective]
    end
    alias them objective

    # @param entity [#person, #plural?, #gender]
    # @return [String]
    def objective_(entity)
      objective(entity).cap_first
    end
    alias them_ objective_

    # @param entity [#person, #plural?, #gender]
    # @return [String]
    def possessive(entity)
      map(entity)[:possessive]
    end
    alias their possessive

    # @param entity [#person, #plural?, #gender]
    # @return [String]
    def possessive_(entity)
      possessive(entity).cap_first
    end
    alias their_ possessive_

    # @param entity [#person, #plural?, #gender]
    # @return [String]
    def reflexive(entity)
      map(entity)[:reflexive]
    end
    alias themselves reflexive
    alias themself reflexive

    # @param entity [#person, #plural?, #gender]
    # @return [String]
    def reflexive_(entity)
      reflexive(entity).cap_first
    end
    alias themselves_ reflexive_
    alias themself_ reflexive_

    # @param entity [#person, #plural?, #gender]
    # @return [Hash]
    def map(entity)
      plurality = (entity.plural? ? :plural : :singular)
      maps[[(entity.person || 3), plurality, entity.gender]] ||
        maps[[(entity.person || 3), plurality]]
    end

    private

    def maps
      @maps ||= {
        [1, :singular] => Hash[map_keys.zip(%w[I me my myself])],
        [2, :singular] => Hash[map_keys.zip(%w[you you your yourself])],
        [3, :singular] => Hash[map_keys.zip(%w[it it its itself])],
        [3, :singular, :male] => Hash[map_keys.zip(%w[he him his himself])],
        [3, :singular, :female] => Hash[map_keys.zip(%w[she her her herself])],
        [3, :singular, :other] => Hash[map_keys.zip(%w[they them their themselves])],
        [3, :singular, :neutral] => Hash[map_keys.zip(%w[it it its itself])],
        [1, :plural] => Hash[map_keys.zip(%w[we us our ourselves])],
        [2, :plural] => Hash[map_keys.zip(%w[you you your yourselves])],
        [3, :plural] => Hash[map_keys.zip(%w[they them their themselves])]
      }
    end

    def map_keys
      @map_keys ||= %i[subjective objective possessive reflexive]
    end
  end
end
