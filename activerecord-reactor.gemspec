$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'active_record/reactor/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name          = 'activerecord-reactor'
  s.version       = ActiveRecord::Reactor::VERSION
  s.date          = '2023-05-16'
  s.summary       = 'Controlled reactions on ActiveRecord callbacks'
  s.description   = %{ActiveRecord Reactors provide a defined way to react on default or custom Active Record callbacks. Observers without the magic, and without the hassle.}
  s.authors       = ['Matthias Grosser']
  s.email         = 'mtgrosser@gmx.net'
  s.require_path  = 'lib'
  s.files         = Dir['{lib}/**/*.rb', 'MIT-LICENSE', 'README.md', 'CHANGELOG', 'Rakefile']
  s.homepage      = 'https://github.com/mtgrosser/activerecord-reactor'

  s.test_files = Dir["test/**/*"]

  s.add_runtime_dependency 'activerecord', '~> 7.0.0'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rake', '>= 0.8.7'
  #s.add_development_dependency 'debugger'
end
