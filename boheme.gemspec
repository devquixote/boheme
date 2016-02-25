# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'boheme/version'

Gem::Specification.new do |spec|
  spec.name          = "boheme"
  spec.version       = Boheme::VERSION
  spec.authors       = ["Lance Woodson"]
  spec.email         = ["lance.woodson@bazaarvoice.com"]

  spec.summary       = %q{DSL for container-based workflows}
  spec.description   = %q{Boheme is a DSL for defining container-based execution pipelines composed of related and possibly dependent services and tasks}
  spec.homepage      = "https://github.com/devquixote/boheme"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
