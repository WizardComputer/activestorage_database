require_relative "lib/activestorage_database/version"

Gem::Specification.new do |spec|
  spec.name        = "activestorage_database"
  spec.version     = ActivestorageDatabase::VERSION
  spec.authors     = ["Dino Maric"]
  spec.email       = ["dino.onex@gmail.com"]
  spec.homepage    = "https://github.com/WizardComputer/activestorage_database"
  spec.summary     = "Store ActiveStorage attachments inside the database."
  spec.description = "Store ActiveStorage attachments inside the database."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/WizardComputer/activestorage_database"
  spec.metadata["changelog_uri"] = "https://github.com/WizardComputer/activestorage_database"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 6.0.0"
end
