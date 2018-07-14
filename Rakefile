require 'bundler/setup'
require 'rake'
require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'yard'
require 'yard/rake/yardoc_task'

HATEMILE_GEM = Gem::Specification.load('hatemile.gemspec')

Gem::PackageTask.new(HATEMILE_GEM) do |p|
  p.gem_spec = HATEMILE_GEM
end

YARD::Rake::YardocTask.new do |p|
  p.files = ['lib/**/*.rb', '-', 'README.md', 'CODE_OF_CONDUCT.md', 'LICENSE']
end
