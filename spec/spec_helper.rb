begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'rubygems'
require 'active_support'
require 'active_record'
require 'action_controller'

require 'acts_as_api'

require 'spec_models'

