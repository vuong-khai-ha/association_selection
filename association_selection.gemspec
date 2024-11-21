# frozen_string_literal: true

require_relative 'lib/association_selection/version'

Gem::Specification.new do |spec|
  spec.name          = 'association_selection'
  spec.version       = AssociationSelection::VERSION
  spec.authors       = ['Vương Khải Hà']
  spec.email         = ['inki.personal@gmail.com']

  spec.licenses      = ['MIT']
  spec.homepage      = 'https://github.com/vuong-khai-ha/association_selection'
  spec.summary       = 'Select fields for ActiveRecord associations'
  spec.description   = 'Provides functionality to specify fields to preload for ActiveRecord associations.'

  spec.metadata = {
    'bug_tracker_uri'       => 'https://github.com/vuong-khai-ha/association_selection/issues',
    'changelog_uri'         => "https://github.com/vuong-khai-ha/association_selection/releases/tag/v#{AssociationSelection::VERSION}",
    'source_code_uri'       => "https://github.com/vuong-khai-ha/association_selection/tree/v#{AssociationSelection::VERSION}",
    'rubygems_mfa_required' => 'true',
  }

  spec.files         = Dir['lib/**/*.rb', 'MIT-LICENSE', 'Rakefile', 'README.md']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0'
end
