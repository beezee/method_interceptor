# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'method_interceptor/version'

Gem::Specification.new do |spec|
  spec.name          = "method_interceptor"
  spec.version       = MethodInterceptor::VERSION
  spec.authors       = ["Brian Zeligson"]
  spec.email         = ["brian.zeligson@gmail.com"]
  spec.summary       = %q{Provides a proxy object that allows consistent transformation of arguments passed to and responses received from target object methods}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
