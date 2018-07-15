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

namespace(:doc) do
  desc('Check documentation coverage')
  task(:coverage) do
    # Reference https://github.com/umbrellio/lamian/blob/master/Rakefile
    YARD::Registry.load
    objs = YARD::Registry.select do |o|
      puts("pending #{o}") if o.docstring =~ /TODO|FIXME|@pending|@todo/
      o.docstring.blank?
    end

    next if objs.empty?

    puts('No documentation found for:')
    objs.each do |x|
      puts("\t#{x}")
    end

    abort('100% document coverage required')
  end
end

desc('Generate documentation')
task('doc' => 'yard')

desc('Analyze code to flag bugs and stylistic errors.')
task('lint' => ['rubocop', 'doc:coverage'])

desc('Build the gem if not has errors')
task('build' => %w[lint gem])
