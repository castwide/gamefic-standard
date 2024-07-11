# frozen_string_literal: true

module Gamefic
  module Standard
    script do
      meta :verbs do |actor|
        list = rulebook.synonyms.reject { |syn| syn.to_s.start_with?('_') }
                      .map { |syn| "<kbd>#{syn}</kbd>"}
                      .join_and
        actor.tell "I understand the following commands: #{list}."
        actor.tell "Try using commands in plain sentences like <kbd>go north</kbd> or <kbd>take the coin</kbd>."
        actor.tell "For more information about a specific command, try <kbd>help [command]</kbd>, e.g., <kbd>help go</kbd>."
      end

      interpret 'commands', 'verbs'
      interpret 'help', 'verbs'

      meta :help, plaintext do |actor, command|
        if rulebook.synonyms.include?(command.to_sym) && !command.start_with?('_')
          available = rulebook.syntaxes.select { |syntax| syntax.synonym == command.to_sym }
                              .uniq(&:signature)
          examples = available.map(&:template)
                              .map do |tmpl|
                                tmpl.text
                                    .gsub(/:character/i, '[someone]')
                                    .gsub(/:var[0-9]?/i, '[something]')
                                    .gsub(/:([a-z0-9]+)/i, "[\\1]")
                              end
                              .reject { |tmpl| tmpl.include?('[something] [something]') }
          actor.tell 'Examples:'
          actor.stream '<ul>'
          examples.each do |xmpl|
            actor.stream "<li><kbd>#{xmpl}</kbd></li>"
          end
          actor.stream '</ul>'
          related = available.map(&:verb)
                              .uniq
                              .that_are_not(command.to_sym)
                              .sort
                              .map { |sym| "<kbd>#{sym}</kbd>"}
          next if related.empty?

          actor.tell "Related: #{related.join(', ')}"
        elsif command =~ /[^a-z]/i
          actor.tell "Try asking for help with a specific command, e.g., <kbd>help go</kbd>"
        else
          actor.tell "\"#{command.cap_first}\" is not a verb I understand."
        end
      end
    end
  end
end
