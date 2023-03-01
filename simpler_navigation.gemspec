# frozen_string_literal: true

require_relative "lib/simpler_navigation/version"

Gem::Specification.new do |spec|
  spec.name = "simpler_navigation"
  spec.version = SimplerNavigation::VERSION
  spec.authors = ["Nick Muerdter"]
  spec.email = ["12112+GUI@users.noreply.github.com"]

  spec.summary = "A Rails gem to handle navigation menus and breadcrumbs."
  spec.homepage = "https://github.com/GUI/simpler_navigation"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/GUI/simpler_navigation"
  spec.metadata["changelog_uri"] = "https://github.com/GUI/simpler_navigation/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "actionview"
  spec.add_dependency "railties"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
