require 'bundler'
require 'rspec/core'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new

namespace :spec do

  desc "Run ActiveRecord RSpec code examples only"
  RSpec::Core::RakeTask.new do |t|
    t.name = :active_record
    t.rspec_opts = ["--color", "--format", "documentation", "--tag", "orm:active_record"]
  end

end

gemspec = Gem::Specification.load("acts_as_api.gemspec")

task :default => :spec

desc "Generate the gh_pages site"
task :rocco do
  system "bundle exec rocco examples/introduction/index.rb -t examples/introduction/layout.mustache"
end
