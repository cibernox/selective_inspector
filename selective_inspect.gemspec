# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'selective_inspect/version'

Gem::Specification.new do |spec|
  spec.name          = "selective_inspect"
  spec.version       = SelectiveInspect::VERSION
  spec.authors       = ["Miguel Camba"]
  spec.email         = ["miguel.camba@gmail.com"]
  spec.description   = %q{Simple gem to allow to customize the output of the inspect methods}
  spec.summary       = %q{Customize the inspect's output of your objects white/black listing instance variables}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
