# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qwrapper/version'

Gem::Specification.new do |spec|

  spec.name          = "qwrapper"
  spec.version       = Qwrapper::VERSION
  spec.authors       = ["Nirmit Patel"]
  spec.email         = ["nirmit@patelify.com"]
  spec.summary       = %q{ QWrapper is an abstract API which makes working with
                           different message queues simple. }
  spec.description   = %q{ QWrapper's purpose to make it simple to work different
                           differnt message queues. }
  spec.homepage      = "http://github.com/patelify/qwrapper"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

end
