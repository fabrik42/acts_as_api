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
      t.rspec_opts = ["--color"]
    end

    task "prepare_#{orm}" do
      ENV['ACTS_AS_API_ORM'] = orm
    end

    Rake::Task["spec:#{orm}"].prerequisites << "spec:prepare_#{orm}"
  end


#  task :all => supported_orms.map{|orm| "spec:#{orm}"}

  desc "Runs specs for all ORMs (#{supported_orms.join(', ')})"
  task :all do
    supported_orms.each do |orm|
      puts "Starting to run specs for #{orm}..."
      system("bundle exec rake spec:#{orm}")
      raise "#{orm} failed!" unless $?.exitstatus == 0
    end
  end

end


gemspec = Gem::Specification.load("acts_as_api.gemspec")

task :default => "spec:all"

desc "Generate the gh_pages site"
task :rocco do
  system "bundle exec rocco examples/introduction/index.rb -t examples/introduction/layout.mustache"
end
