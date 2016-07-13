# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bestiary/version'

Gem::Specification.new do |spec|
  spec.name = 'Bestiary'
  spec.version = Bestiary::VERSION
  spec.authors = ['Edward Loveall']
  spec.email = ['edward@edwardloveall.com']

  spec.summary = 'Turn the pathfinder bestiary into a database'
  spec.description = 'Convert the html files at http://paizo.com/pathfinderRPG/prd/indices/bestiary.html into data sutable to insert into a SQL database'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.3'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'nokogiri', '~> 1.6.8'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rspec', '~> 3.4'
end
