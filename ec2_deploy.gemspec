# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ec2_deploy/version'

Gem::Specification.new do |spec|
  spec.name          = "ec2_deploy"
  spec.version       = EC2Deploy::VERSION
  spec.authors       = ["Massimo Maino"]
  spec.email         = ["maintux@gmail.com"]
  spec.description   = %q{Provides a recipe for setup domain by AWS EC2 tagging system}
  spec.summary       = %q{Recipe for deploy with a Autoscaling Group in Amazon AWS}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'aws-sdk'
  spec.add_runtime_dependency 'capistrano', '~> 3.0.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'aws-sdk'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'capistrano', '~> 3.0.1'

end
