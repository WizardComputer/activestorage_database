require_relative "lib/activestorage_database/version"

Gem::Specification.new do |spec|
  spec.name        = "activestorage_database"
  spec.version     = ActivestorageDatabase::VERSION
  spec.authors     = ["Dino Maric", "Sinan Mujan"]
  spec.email       = ["dinom@hey.com"]
  spec.homepage    = "https://github.com/WizardComputer/activestorage_database"
  spec.summary     = "Store ActiveStorage attachments inside the database."
  spec.description = "Store ActiveStorage attachments inside the database."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/WizardComputer/activestorage_database"
  spec.metadata["changelog_uri"] = "https://github.com/WizardComputer/activestorage_database"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 7.0"
end
