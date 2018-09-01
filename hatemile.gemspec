require 'date'
require 'rubygems'

Gem::Specification.new do |gem|
  gem.name = 'hatemile'
  gem.version = '1.0'
  gem.date = Date.today.to_s

  gem.summary = 'HaTeMiLe can convert HTML code in a code more accessible.'
  gem.description = 'HaTeMiLe (HTML Accessible) is a open source library ' \
    'developed to improve accessibility converting a HTML code in a new HTML ' \
    'code more accessible, its features is based in WCAG 2.0 document, eMAG ' \
    '3.1 document and some features of Job Access With Speech (JAWS), Opera ' \
    'before version 15 and Mozilla Firefox.'
  gem.license = 'Apache-2.0'

  gem.author = 'Carlson Santana Cruz'
  gem.email = 'hatemileforall@gmail.com'
  gem.homepage = 'https://github.com/hatemile/hatemile-for-ruby'

  gem.files = Dir[
    'CODE_OF_CONDUCT.md',
    'Gemfile',
    'hatemile.gemspec',
    'LICENSE',
    'Rakefile',
    'README',
    '{bin,lib,man,test,spec}/**/*'
  ]

  gem.add_runtime_dependency('css_parser')
  gem.add_runtime_dependency('nokogiri')

  gem.add_development_dependency('bundler')
  gem.add_development_dependency('rubocop')
  gem.add_development_dependency('yard')
end
