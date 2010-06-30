require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/acts_as_api'

Hoe.plugin :newgem
# Hoe.plugin :website
# Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'acts_as_api' do
  self.developer 'Christian Bäuerlein', 'christian@ffwdme.com'
  #self.post_install_message = 'PostInstall.txt' # TODO remove if post-install message not required
  #self.rubyforge_name       = self.name # TODO this is default value
  self.extra_deps         = [['activerecord','>= 3.0.0.beta4'], ['actionpack','>= 3.0.0.beta4']]

end

require 'newgem/tasks'
# In Netbeans the next lines causes every rspec test to run twice.
# If you're not using Netbeans and having problem with testing - try to disable it.
#Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]
