# coding: utf-8
$LOAD_PATH << File.expand_path("../lib", __FILE__)
require 'butterfli/version'

Gem::Specification.new do |s|
  s.name          = "butterfli"
  s.version       = Butterfli::VERSION
  s.authors       = ["David Elner"]
  s.email         = ["david@davidelner.com"]
  s.summary       = %q{Processes data from external APIs into common container.}
  s.description   = %q{Processes data from external APIs into common container, typically from social media.}
  s.homepage      = "http://github.com/delner/butterfli"
  s.license       = "MIT"

  s.files       = `git ls-files`.split("\n")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files  = `git ls-files -- {spec,features,gemfiles}/*`.split("\n")

  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")

  # Future dependencies:
  # s.add_dependency "instagram"
  # s.add_dependency "httparty"

  s.add_development_dependency "bundler", "~> 1.7"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 3.3"
  s.add_development_dependency "pry"
  s.add_development_dependency("pry-stack_explorer", "~> 0.4.9")
end
