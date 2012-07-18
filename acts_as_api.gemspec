# encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)
require "acts_as_api/version"

Gem::Specification.new do |s|
  s.name        = "acts_as_api"
  s.version     = ActsAsApi::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Christian Bäuerlein"]
  s.email       = ["christian@ffwdme.com"]
  s.homepage    = "https://github.com/fabrik42/acts_as_api"
  s.summary     = %q{Makes creating XML/JSON responses in Rails 3 easy and fun.}
  s.description = %q{acts_as_api enriches the models and controllers of your app in a rails-like way so you can easily determine how your XML/JSON API responses should look like.}

  s.add_dependency('activemodel','>= 3.0.0')
  s.add_dependency('activesupport','>= 3.0.0')
  s.add_dependency('rack','>= 1.1.0')

  s.add_development_dependency('rails', ['>= 3.2.3'])
  s.add_development_dependency('mongoid', ['>= 3.0.1'])

  s.rdoc_options  = ['--charset=UTF-8']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
