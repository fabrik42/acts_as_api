require "rails_app/config/environment"


$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'acts_as_api'

ENV["RAILS_ENV"] = "test"

load_schema = lambda {
  load "#{Rails.root.to_s}/db/schema.rb" # use db agnostic schema by default
  # ActiveRecord::Migrator.up('db/migrate') # use migrations
}
silence_stream(STDOUT, &load_schema)
