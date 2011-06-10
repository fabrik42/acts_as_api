require 'bundler'
require 'rspec/core'
require 'rspec/core/rake_task'
#require 'rake/rdoctask'

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

# causes crash in travis ci
#Rake::RDocTask.new do |rdoc|
#  rdoc.rdoc_dir = 'doc'
#  rdoc.title = "#{gemspec.name} #{gemspec.version}"
#  rdoc.options += gemspec.rdoc_options
#  rdoc.options << '--line-numbers' << '--inline-source'  
#  rdoc.rdoc_files.include(gemspec.extra_rdoc_files)
#  rdoc.rdoc_files.include('README.rdoc')
#end

#bundle exec rocco examples/introduction/index.rb -t examples/introduction/layout.mustache
