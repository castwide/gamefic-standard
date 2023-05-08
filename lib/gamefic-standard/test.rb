module Testable
  module_function

  def test_procs
    @test_procs ||= Hash.new
  end
end

Gamefic::Plot.include Testable

module Tests
  def on_test name = :me, &block
    test_procs[name] = block
  end

  def test? name
    test_procs.key?(name)
  end

  def run_test name, actor
    queue = []
    test_procs[name].call(actor, queue)
    actor.queue.concat queue
  end
end

Gamefic::Plot::ScriptMethods.include Tests

# @todo For some reason, this include is necessary in Opal
Gamefic::Plot.include Tests if RUBY_ENGINE == 'opal'

Gamefic.script do
  meta :test, plaintext do |actor, name|
    sym = name.to_sym
    if test?(sym)
      run_test sym, actor
    else
      actor.tell "There's no test named \"#{name}\" in this game."
    end
  end
end
