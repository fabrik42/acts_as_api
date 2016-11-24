$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'shared_engine/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'shared_engine'
  s.version     = SharedEngine::VERSION
  s.authors     = ['Your name']
  s.email       = ['Your email']
  s.summary     = 'Summary of SharedEngine.'
  s.description = 'Description of SharedEngine.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '~> 5.0.0.1'
  s.add_development_dependency 'sqlite3'
end
