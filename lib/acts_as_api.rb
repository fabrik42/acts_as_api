require 'active_model'
require 'active_support/core_ext/class'

require 'acts_as_api/collection'
require 'acts_as_api/rails_renderer'
require 'acts_as_api/exceptions'

# acts_as_api is a gem that aims to make the construction of JSON and XML
# responses in Rails 3, 4 and 5 easy and fun.
#
# Therefore it attaches a couple of helper methods to active record and
# the action controller base classes.
#
# acts_as_api uses the default serializers of your rails app and doesn't
# force you into more dependencies.
module ActsAsApi
  autoload :Config,      'acts_as_api/config'
  autoload :ApiTemplate, 'acts_as_api/api_template'
  autoload :Base,        'acts_as_api/base'
  autoload :Rendering,   'acts_as_api/rendering'
  autoload :Responder,   'acts_as_api/responder'
  autoload :Adapters,    'acts_as_api/adapters'
end

# Neccessary to render an Array of models, e.g. the result of a search.
Array.include(ActsAsApi::Collection)

# Attach ourselves to ActiveRecord
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend ActsAsApi::Base

  # Rails 5 compatibility
  if defined?(ActiveRecord::Relation)
    ActiveRecord::Relation.include(ActsAsApi::Collection)
  end

  if defined?(ActiveRecord::Associations::CollectionProxy)
    ActiveRecord::Associations::CollectionProxy.include(ActsAsApi::Collection)
  end

  if defined?(ActiveRecord::AssociationRelation)
    ActiveRecord::AssociationRelation.include(ActsAsApi::Collection)
  end
end

# Attach ourselves to ActiveResource
if defined?(ActiveResource::Base)
  ActiveResource::Base.extend ActsAsApi::Base
end

# Attach ourselves to Mongoid
if defined?(Mongoid::Document)
  Mongoid::Document.send :include, ActsAsApi::Adapters::Mongoid
end

# Attach ourselves to the action controller of Rails
if defined?(ActionController::Base)
  ActionController::Base.send :include, ActsAsApi::Rendering
  ActsAsApi::RailsRenderer.setup
end
