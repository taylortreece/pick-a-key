# frozen_string_literal: true

require_relative "lib/pick_a_key/version"

Gem::Specification.new do |spec|
  spec.name          = "pick_a_key"
  spec.version       = PickAKey::VERSION
  spec.authors       = ["Taylor Treece"]
  spec.email         = ["xxxxxxxx.com"]

  spec.summary       = "The Pick-a-Key gem allows you to quickly find relevant information on music theory, specifically relating to Major and Minor keys."
  spec.description   = "When started, the gem lists all available Major and minor keys, and then prompts you to make a selection. Once selected, a key object is made a available to the user. The attributes related to the key object are :Type (Major or minor), :Name (e.g. C Major ), :Notes (all notes in the listed key), :Chords (all chords in listed key), :Relative_fifth, :Relative_Major/:Relative_minor. The user also has the option of having a single random chord progression returned to them in a key of their choice, or an entire song written in the key of their choice."
  spec.homepage      = "https://github.com/taylortreece/pick-a-key.git."
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["allowed_push_host"] = 'http://mygemserver.com'

  #spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  #spec.bindir        = "exe"
  spec.executables   = ["pick-a-key"]
  #spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency "pry"
  spec.add_dependency "nokogiri"
  spec.add_dependency "prettyprint"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"


  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
