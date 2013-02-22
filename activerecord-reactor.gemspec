$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'active_record/reactor/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = 'activerecord-reactor'
  s.version       = ActiveRecord::Reactor::VERSION
  s.date          = '2013-02-22'
  s.summary       = 'Unobtrusive observers for Rails models'
  s.description   = ''
  s.authors       = ['Matthias Grosser']
  s.email         = 'mtgrosser@gmx.net'
  s.require_path  = 'lib'
  s.files         = Dir['{lib}/**/*.rb', 'MIT-LICENSE', 'README.md', 'CHANGELOG', 'Rakefile']
  s.homepage      = 'https://github.com/mtgrosser/activerecord-reactor'

  s.test_files = Dir["test/**/*"]

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency "activerecord", "~> 3.2.3"

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rake', '>= 0.8.7'
  s.add_development_dependency 'debugger'
end
