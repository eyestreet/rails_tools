# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rails_tools/version"

Gem::Specification.new do |s|
  s.name        = "rails_tools"
  s.version     = RailsTools::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Pat George"]
  s.email       = ["pat.george@eyestreet.com"]
  s.homepage    = ""
  s.summary     = %q{This gem includes Rake tasks we use internally in Rails projects such as Heroku deployment and changelog generation using git and Pivotal Tracker}
  s.description = %q{Right now this gem contains two sets of Rake tasks.  The first handles deployment to a Heroku environment for both staging and production environments.  The second is a single Rake task for generating a changelog by cross referencing your git commits with the Pivotal Tracker stories referenced in the commit messages.}

  s.rubyforge_project = "rails_tools"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "heroku"
  s.add_dependency "pivotal-tracker"
end
