lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gamefic/standard/version'

Gem::Specification.new do |spec|
  spec.name          = 'gamefic-standard'
  spec.version       = Gamefic::Standard::VERSION
  spec.authors       = ['Fred Snyder']
  spec.email         = ['fsnyder@castwide.com']

  spec.summary       = 'The Gamefic standard script library.'
  spec.description   = 'A collection of components for building games and interactive fiction in Gamefic.'
  spec.homepage      = 'https://gamefic.com'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  #   spec.metadata["homepage_uri"] = spec.homepage
  #   spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  #   spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7.0'

  spec.add_dependency 'gamefic', '~> 4.0'
  spec.add_dependency 'gamefic-grammar', '~> 1.1'
  spec.add_dependency 'gamefic-what', '~> 1.1'

  spec.add_development_dependency 'opal', '~> 1.7'
  spec.add_development_dependency 'opal-rspec', '~> 1.0'
  spec.add_development_dependency 'opal-sprockets', '~> 1.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.14'
end
