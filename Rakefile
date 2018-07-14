require 'rake'
require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'

HATEMILE_GEM = Gem::Specification.load('hatemile.gemspec')

Gem::PackageTask.new(HATEMILE_GEM) do |p|
  p.gem_spec = HATEMILE_GEM
end
