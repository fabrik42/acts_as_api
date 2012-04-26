if defined?(Mongoid::Document)
  Mongoid::Document.send :include, ActsAsApi::Adapters::Mongoid
end