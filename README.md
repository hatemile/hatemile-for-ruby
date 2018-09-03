HaTeMiLe for Ruby
=================

HaTeMiLe (HTML Accessible) is a library that can convert a HTML code in a HTML code more accessible.

## Accessibility solutions

* [Associate HTML elements](https://github.com/hatemile/hatemile-for-ruby/wiki/Associate-HTML-elements);
* [Provide a polyfill to CSS Speech and CSS Aural properties](https://github.com/hatemile/hatemile-for-ruby/wiki/Provide-a-polyfill-to-CSS-Speech-and-CSS-Aural-properties);
* [Display inacessible informations of page](https://github.com/hatemile/hatemile-for-ruby/wiki/Display-inacessible-informations-of-page);
* [Enable all functionality of page available from a keyboard](https://github.com/hatemile/hatemile-for-ruby/wiki/Enable-all-functionality-of-page-available-from-a-keyboard);
* [Improve the acessibility of forms](https://github.com/hatemile/hatemile-for-ruby/wiki/Improve-the-acessibility-of-forms);
* [Provide accessibility resources to navigate](https://github.com/hatemile/hatemile-for-ruby/wiki/Provide-accessibility-resources-to-navigate).

## Documentation

To generate the full API documentation of HaTeMiLe of Ruby:

1. [Install dependencies](https://bundler.io/man/bundle-install.1.html);
2. Execute the Rake task `doc` in directory;
    ```bash
    rake doc
    ```
3. Open the `doc/index.html` with an internet browser.

## Usage

Import all needed classes:

```ruby
require 'rubygems'
require 'bundler/setup'

require 'hatemile/util/configure'
require 'hatemile/util/html/nokogiri/nokogiri_html_dom_parser'
require 'hatemile/util/css/rcp/rcp_parser'
require 'hatemile/implementation/accessible_css_implementation'
require 'hatemile/implementation/accessible_display_implementation'
require 'hatemile/implementation/accessible_event_implementation'
require 'hatemile/implementation/accessible_form_implementation'
require 'hatemile/implementation/accessible_navigation_implementation'
require 'hatemile/implementation/accessible_association_implementation'
```

Instanciate the configuration, the parsers and solution classes and execute them:

```ruby
configure = Hatemile::Util::Configure.new

html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(html_code)
css_parser = Hatemile::Util::Css::Rcp::RCPParser.new(html_parser, current_url)

events = Hatemile::Implementation::AccessibleEventImplementation.new(html_parser)
css = Hatemile::Implementation::AccessibleCSSImplementation.new(html_parser, css_parser, configure)
forms = Hatemile::Implementation::AccessibleFormImplementation.new(html_parser)
navigation = Hatemile::Implementation::AccessibleNavigationImplementation.new(html_parser, configure)
association = Hatemile::Implementation::AccessibleAssociationImplementation.new(html_parser)
display = Hatemile::Implementation::AccessibleDisplayImplementation.new(html_parser, configure)

events.make_accessible_all_drag_and_drop_events
events.make_accessible_all_click_events
events.make_accessible_all_hover_events

forms.mark_all_autocomplete_fields
forms.mark_all_range_fields
forms.mark_all_required_fields
forms.mark_all_invalid_fields

association.associate_all_data_cells_with_header_cells
association.associate_all_labels_with_fields

css.provide_all_speak_properties

display.display_all_shortcuts
display.display_all_roles
display.display_all_cell_headers
display.display_all_waiaria_states
display.display_all_links_attributes
display.display_all_titles
display.display_all_languages
display.display_all_alternative_text_images

navigation.provide_navigation_by_all_headings
navigation.provide_navigation_by_all_skippers
navigation.provide_navigation_to_all_long_descriptions

display.display_all_shortcuts

puts(html_parser.get_html)
```

## Contributing

If you want contribute with HaTeMiLe for Ruby, read [contributing guidelines](https://github.com/hatemile/hatemile-for-ruby/blob/master/CONTRIBUTING.md).

## See also
* [HaTeMiLe for CSS](https://github.com/hatemile/hatemile-for-css)
* [HaTeMiLe for JavaScript](https://github.com/hatemile/hatemile-for-javascript)
* [HaTeMiLe for Java](https://github.com/hatemile/hatemile-for-java)
* [HaTeMiLe for PHP](https://github.com/hatemile/hatemile-for-php)
* [HaTeMiLe for Python](https://github.com/hatemile/hatemile-for-python)
