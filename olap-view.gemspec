# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require 'olap/view/version'

Gem::Specification.new do |spec|
  spec.name          = "olap-view"
  spec.version       = Olap::View::VERSION
  spec.authors       = ["stepanovit"]
  spec.email         = ["stepanov@wondersoft.ru"]
  spec.summary       = %q{OLAP VIEW gem}
  spec.description   = %q{Ruby On Rails gem to visualize by Google Charts MDX queries on OLAP databases using XMLA connection. Can be used with any XMLA-compliant server, like Olaper or Mondrian.}
  spec.homepage      = "https://github.com/Wondersoft/olap-view"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "olap-xmla", '~> 0'
end