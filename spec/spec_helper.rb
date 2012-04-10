ENV["RAILS_ENV"] = "test"

if ENV['ACTS_AS_API_ORM'] == 'active_record'
  require "active_record_dummy/config/environment"

  load_schema = lambda {
    load "#{Rails.root.to_s}/db/schema.rb" # use db agnostic schema by default
    # ActiveRecord::Migrator.up('db/migrate') # use migrations
  }
  silence_stream(STDOUT, &load_schema)

elsif ENV['ACTS_AS_API_ORM'] == 'mongoid'

  require "mongoid_dummy/config/environment"

end

require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|file| require file }
