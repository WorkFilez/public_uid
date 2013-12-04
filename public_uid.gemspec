# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'public_uid/version'

Gem::Specification.new do |spec|
  spec.name          = "public_uid"
  spec.version       = PublicUid::VERSION
  spec.authors       = ["Tomas Valent"]
  spec.email         = ["equivalent@eq8.eu"]
  spec.description   = %q{Automatic generates public unique identifier for model}
  spec.summary       = %q{Automatic generates public UID column}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "activerecord", "~> 3.2"
  spec.add_development_dependency "minitest", "~> 5"
  spec.add_development_dependency "sqlite3"
end
