require 'bundler/setup'
require 'rake'
require 'rake/clean'
require 'rubocop/rake_task'
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

RuboCop::RakeTask.new(:rubocop) do |p|
  p.patterns = ['Rakefile', 'hatemile.gemspec', 'lib/**/*.rb']
  p.fail_on_error = true
end
