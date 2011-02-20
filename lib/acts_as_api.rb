require 'set'
require 'active_model'
require 'active_support/core_ext/class'

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
  
 require "acts_as_api/array"
 require "acts_as_api/rails_renderer"

# acts_as_api is a gem that aims to make the construction of JSON and XML
# responses in rails 3 easy and fun.
#
# Therefore it attaches a couple of helper methods to active record and
# the action controller base classes.
#
# acts_as_api uses the default serializers of your rails app and doesn't
# force you into more dependencies.
module ActsAsApi
  autoload :Config,       "acts_as_api/config"
  autoload :ApiTemplate,  "acts_as_api/api_template"
  autoload :Base,         "acts_as_api/base"
  autoload :Rendering,    "acts_as_api/rendering"    
end

# Attach ourselves to active record
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend ActsAsApi::Base
end

# Attach ourselves to the action controller of rails
if defined?(ActionController::Base)
  ActionController::Base.send :include, ActsAsApi::Rendering
  ActsAsApi::RailsRenderer.setup
end