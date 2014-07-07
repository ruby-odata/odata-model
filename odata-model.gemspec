# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'odata/model/version'

Gem::Specification.new do |spec|
  spec.name          = 'odata-model'
  spec.version       = OData::Model::VERSION
  spec.authors       = ['James Thompson']
  spec.email         = %w{james@buypd.com}
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = 'https://github.com/ruby-odata/odata-model'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %q{lib}

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'simplecov', '~> 0.8.2'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'rspec', '~> 3.0.0'

  spec.add_dependency 'odata', '~> 0.1.0'
  spec.add_dependency 'activemodel', '>= 3.0.0'
end
