# At the moment we need to include the Mongoid adapter here
# in the initializers, as it doesn't get recognized in the
# lib itself!
if defined?(Mongoid::Document)
  Mongoid::Document.send :include, ActsAsApi::Adapters::Mongoid	
end