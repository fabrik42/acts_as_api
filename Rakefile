require 'bundler'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'rake/rdoctask'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new

gemspec = Gem::Specification.load("acts_as_api.gemspec")

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = "#{gemspec.name} #{gemspec.version}"
  rdoc.options += gemspec.rdoc_options
  rdoc.rdoc_files.include(gemspec.extra_rdoc_files)
  rdoc.rdoc_files.include('lib/**/*.rb')
end

#bundle exec rocco examples/introduction/intro.rb -t examples/introduction/intro.mustache
