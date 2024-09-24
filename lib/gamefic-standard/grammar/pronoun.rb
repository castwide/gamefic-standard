# frozen_string_literal: true

module Gamefic
  module Standard
    module Grammar
      # Methods to select pronouns based on an entity's attributes, such as
      # gender.
      #
      module Pronoun
        module_function

        MAP_KEYS = %i[subjective objective possessive reflexive].freeze

        MAPS = {
          [1, :singular] => Hash[MAP_KEYS.zip(%w[I me my myself])],
          [2, :singular] => Hash[MAP_KEYS.zip(%w[you you your yourself])],
          [3, :singular] => Hash[MAP_KEYS.zip(%w[it it its itself])],
          [3, :singular, :male] => Hash[MAP_KEYS.zip(%w[he him his himself])],
          [3, :singular, :female] => Hash[MAP_KEYS.zip(%w[she her her herself])],
          [3, :singular, :other] => Hash[MAP_KEYS.zip(%w[they them their themselves])],
          [3, :singular, :neutral] => Hash[MAP_KEYS.zip(%w[it it its itself])],
          [1, :plural] => Hash[MAP_KEYS.zip(%w[we us our ourselves])],
          [2, :plural] => Hash[MAP_KEYS.zip(%w[you you your yourselves])],
          [3, :plural] => Hash[MAP_KEYS.zip(%w[they them their themselves])]
        }.freeze

        # @param entity [#person, #plural?, #gender]
        # @return [String]
        def subjective(entity)
          prounoun_map(entity)[:subjective]
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
          prounoun_map(entity)[:objective]
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
          prounoun_map(entity)[:possessive]
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
          prounoun_map(entity)[:reflexive]
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
        def prounoun_map(entity)
          plurality = (entity.plural? ? :plural : :singular)
          MAPS[[entity.person || 3, plurality, entity.gender]] ||
            MAPS[[entity.person || 3, plurality]]
        end
      end
    end
  end
end
