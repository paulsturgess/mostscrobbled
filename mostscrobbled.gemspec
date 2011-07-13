# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mostscrobbled/version"

Gem::Specification.new do |s|
	s.name        = "mostscrobbled"
	s.version     = Mostscrobbled::VERSION
	s.platform    = Gem::Platform::RUBY
	s.authors     = ["Paul Sturgess"]
	s.email       = ["paulsturgess@gmail.com"]
	s.homepage    = "https://github.com/paulsturgess/mostscrobbled"
	s.summary     = "Extracts your most scrobbled artists from last.fm and turns them into nice ruby objects"
	s.description = "Uses the last.fm api to analyse your scrobbles library and extracts the artists out in order of number of scrobbles"

	s.rubyforge_project = "mostscrobbled"

	s.files         = `git ls-files`.split("\n")
	s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
	s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
	s.require_paths = ["lib"]
	
	s.add_runtime_dependency "nokogiri", "~> 1.4"
	s.add_development_dependency "rspec", "~> 2.0.0.beta.22"
	s.add_development_dependency "fakeweb", "~> 1.3.0"
end
