require 'bundler'
require 'rspec/core'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new

namespace :spec do

  supported_orms = %w(mongoid active_record)

  supported_orms.each do |orm|
    desc "Run #{orm} specs only"
    RSpec::Core::RakeTask.new do |t|
      t.name = orm
#      t.rspec_opts = ["--color", "--format", "documentation", "--tag", "orm:#{orm}"]
#      t.rspec_opts = ["--color", "--format", "documentation"]
      t.rspec_opts = ["--color"]
    end

    task "prepare_#{orm}" do
      ENV['ACTS_AS_API_ORM'] = orm
    end

    Rake::Task["spec:#{orm}"].prerequisites << "spec:prepare_#{orm}"
  end

  desc "Runs specs for all ORMs (#{supported_orms.join(', ')})"
  task :all => supported_orms.map{|orm| "spec:#{orm}"}
end


gemspec = Gem::Specification.load("acts_as_api.gemspec")

task :default => "spec:all"

desc "Generate the gh_pages site"
task :rocco do
  system "bundle exec rocco examples/introduction/index.rb -t examples/introduction/layout.mustache"
end
