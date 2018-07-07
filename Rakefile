require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rubygems/package_task'
require 'rdoc/task'

spec = Gem::Specification.new do |s|
  s.name = 'HaTeMiLe for Ruby'
  s.version = '1.0'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.md', 'LICENSE']
  s.summary = ''
  s.description = s.summary
  s.author = 'Carlson Santana Cruz'
  s.email = ''
  # s.executables = ['your_executable_here']
  s.files = %w[LICENSE README Rakefile] + Dir.glob('{bin,lib,spec}/**/*')
  s.require_path = 'lib'
  s.bindir = 'bin'
end

Gem::PackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

RDoc::Task.new do |rdoc|
  rdoc.main = 'README.md' # page to start on
  rdoc.title = 'HaTeMiLe for Ruby Docs'
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.add('README.md', 'LICENSE')
  rdoc.rdoc_files.add('lib/**/*.rb')
end
