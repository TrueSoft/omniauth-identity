# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/lib/omniauth-identity/version'

Gem::Specification.new do |gem|
  gem.add_runtime_dependency 'omniauth'
  gem.add_runtime_dependency 'bcrypt'

  gem.add_development_dependency 'simplecov', '~> 0.21'
  gem.add_development_dependency 'rack-test', '~> 1.1'
  gem.add_development_dependency 'rake', '~> 13'
  gem.add_development_dependency 'rspec', '~> 3'
  gem.add_development_dependency 'activerecord', '~> 6.0'
  gem.add_development_dependency 'mongoid', '~> 7.2'
  gem.add_development_dependency 'byebug', '~> 11.1'
  # NOTE: Released version of couch_potato depends on activemodel ~> 4.0, so pull latest from github in Gemfile.
  # gem.add_development_dependency 'couch_potato', '~> 1.7'

  gem.name = 'omniauth-identity'
  gem.version = OmniAuth::Identity::VERSION
  gem.description = %q{Internal authentication handlers for OmniAuth.}
  gem.summary = gem.description
  gem.homepage = 'http://github.com/omniauth/omniauth-identity'
  gem.authors = ['Andrew Roberts', 'Michael Bleigh']
  gem.license     = 'MIT'
  gem.files         = Dir["lib/**/*", "LICENSE", "README.md", "CHANGELOG.md"]
  gem.test_files    = Dir["spec/**/*"]
  gem.require_paths = ['lib']
  gem.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if gem.respond_to? :required_rubygems_version=
end
