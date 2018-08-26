# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'rubygems'
require 'bundler/setup'
require 'test/unit'
require 'test/unit/assertions'

require File.join(
  File.dirname(File.dirname(__FILE__)),
  'lib',
  'hatemile',
  'implementation',
  'accessible_display_implementation'
)
require File.join(
  File.dirname(File.dirname(__FILE__)),
  'lib',
  'hatemile',
  'util',
  'configure'
)
require File.join(
  File.dirname(File.dirname(__FILE__)),
  'lib',
  'hatemile',
  'util',
  'html',
  'nokogiri',
  'nokogiri_html_dom_parser'
)

##
# Test methods of Hatemile::Implementation::AccessibleDisplayImplementation
# class.
class TestAccessibleDisplayImplementation < Test::Unit::TestCase
  ##
  # The name of attribute for not modify the elements.
  DATA_IGNORE = 'data-ignoreaccessibilityfix="true"'.freeze

  ##
  # The configuration of HaTeMiLe.
  CONFIGURE = Hatemile::Util::Configure.new.freeze

  ##
  # Test display_all_shortcuts method with container of shorcuts not defined.
  def test_display_all_shortcuts_container_not_defined
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new("
      <!DOCTYPE html>
      <html>
        <head>
          <title>HaTeMiLe Tests</title>
          <meta charset=\"UTF-8\" />
        </head>
        <body>
          <a href=\"https://github.com/hatemile/\" accesskey=\"r\">
            HaTeMiLe in Github
          </a>
          <a href=\"https://hatemile.github.io\" title=\"Site\" accesskey=\"w\">
            Webpage
          </a>
          <a href=\"http://localhost/\" #{DATA_IGNORE} accesskey=\"i\">
            Ignore link
          </a>
          <form action=\"\">
            <label for=\"field1\">Field1</label>
            <input type=\"text\" id=\"field1\" accesskey=\"f\" /><br />
            <input type=\"submit\" value=\"Submit\" accesskey=\"s\" />
          </form>
        </body>
      </html>
    ")
    display = Hatemile::Implementation::AccessibleDisplayImplementation.new(
      html_parser,
      CONFIGURE
    )
    display.display_all_shortcuts
    accesskey_r = html_parser.find('[accesskey="r"]').first_result
    accesskey_w = html_parser.find('[accesskey="w"]').first_result
    accesskey_f = html_parser.find('[accesskey="f"]').first_result
    accesskey_s = html_parser.find('[accesskey="s"]').first_result
    accesskey_i = html_parser.find('[accesskey="i"]').first_result
    reference_r = html_parser.find(
      '[data-attributeaccesskeyof="R"]'
    ).first_result
    reference_w = html_parser.find(
      '[data-attributeaccesskeyof="W"]'
    ).first_result
    reference_f = html_parser.find(
      '[data-attributeaccesskeyof="F"]'
    ).first_result
    reference_s = html_parser.find(
      '[data-attributeaccesskeyof="S"]'
    ).first_result
    reference_i = html_parser.find(
      '[data-attributeaccesskeyof="I"]'
    ).first_result
    shortcut_description_r = html_parser.find(accesskey_r).find_children(
      '[data-attributeaccesskeyof]'
    ).first_result
    shortcut_description_f = html_parser.find('[for="field1"]').find_children(
      '[data-attributeaccesskeyof]'
    ).first_result

    assert_not_nil(html_parser.find('#container-shortcuts-after').first_result)
    assert_equal('HaTeMiLe in Github', accesskey_r.get_attribute('title'))
    assert_equal('Site', accesskey_w.get_attribute('title'))
    assert_equal('Field1', accesskey_f.get_attribute('title'))
    assert_equal('Submit', accesskey_s.get_attribute('title'))
    assert(!accesskey_i.has_attribute?('title'))
    assert_equal(
      'ACCESS KEY PREFIX + R: HaTeMiLe in Github',
      reference_r.get_text_content
    )
    assert_equal('ACCESS KEY PREFIX + W: Site', reference_w.get_text_content)
    assert_equal('ACCESS KEY PREFIX + F: Field1', reference_f.get_text_content)
    assert_equal(
      'ACCESS KEY PREFIX + S: Submit',
      reference_s.get_text_content
    )
    assert_nil(reference_i)
    assert_equal(
      ' (Keyboard shortcut: ACCESS KEY PREFIX + R)',
      shortcut_description_r.get_text_content
    )
    assert_equal(
      ' (Keyboard shortcut: ACCESS KEY PREFIX + F)',
      shortcut_description_f.get_text_content
    )
  end

  ##
  # Test display_all_shortcuts method with container of shortcuts defined.
  def test_display_all_shortcuts_container_defined
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new("
      <!DOCTYPE html>
      <html>
        <head>
          <title>HaTeMiLe Tests</title>
          <meta charset=\"UTF-8\" />
        </head>
        <body>
          <div id=\"container-shortcuts-after\"></div>
          <a href=\"https://github.com/hatemile/\" accesskey=\"r\">
            HaTeMiLe in Github
          </a>
          <a href=\"https://hatemile.github.io\" title=\"Site\" accesskey=\"w\">
            Webpage
          </a>
          <a href=\"http://localhost/\" #{DATA_IGNORE} accesskey=\"i\">
            Ignore link
          </a>
          <form action=\"\">
            <label for=\"field1\">Field1</label>
            <input type=\"text\" id=\"field1\" accesskey=\"f\" /><br />
            <input type=\"submit\" value=\"Submit\" accesskey=\"s\" />
          </form>
        </body>
      </html>
    ")
    display = Hatemile::Implementation::AccessibleDisplayImplementation.new(
      html_parser,
      CONFIGURE
    )
    display.display_all_shortcuts
    accesskey_r = html_parser.find('[accesskey="r"]').first_result
    accesskey_w = html_parser.find('[accesskey="w"]').first_result
    accesskey_f = html_parser.find('[accesskey="f"]').first_result
    accesskey_s = html_parser.find('[accesskey="s"]').first_result
    accesskey_i = html_parser.find('[accesskey="i"]').first_result
    reference_r = html_parser.find(
      '#container-shortcuts-after [data-attributeaccesskeyof="R"]'
    ).first_result
    reference_w = html_parser.find(
      '#container-shortcuts-after [data-attributeaccesskeyof="W"]'
    ).first_result
    reference_f = html_parser.find(
      '#container-shortcuts-after [data-attributeaccesskeyof="F"]'
    ).first_result
    reference_s = html_parser.find(
      '#container-shortcuts-after [data-attributeaccesskeyof="S"]'
    ).first_result
    reference_i = html_parser.find(
      '#container-shortcuts-after [data-attributeaccesskeyof="I"]'
    ).first_result

    assert_equal(
      'container-shortcuts-after',
      html_parser.find(
        'body'
      ).first_result.get_first_element_child.get_attribute('id')
    )
    assert_equal('HaTeMiLe in Github', accesskey_r.get_attribute('title'))
    assert_equal('Site', accesskey_w.get_attribute('title'))
    assert_equal('Field1', accesskey_f.get_attribute('title'))
    assert_equal('Submit', accesskey_s.get_attribute('title'))
    assert(!accesskey_i.has_attribute?('title'))
    assert_equal(
      'ACCESS KEY PREFIX + R: HaTeMiLe in Github',
      reference_r.get_text_content
    )
    assert_equal('ACCESS KEY PREFIX + W: Site', reference_w.get_text_content)
    assert_equal('ACCESS KEY PREFIX + F: Field1', reference_f.get_text_content)
    assert_equal('ACCESS KEY PREFIX + S: Submit', reference_s.get_text_content)
    assert_nil(reference_i)
  end

  ##
  # Test display_all_roles method with container of shortcuts defined.
  def test_display_all_roles
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new("
      <!DOCTYPE html>
      <html role=\"application\">
        <head>
          <title>HaTeMiLe Tests</title>
          <meta charset=\"UTF-8\" />
        </head>
        <body>
          <a href=\"https://github.com/\" role=\"link\">Github</a>
          <span role=\"note\">Span</span>
          <label for=\"field1\">Field1</label>
          <input type=\"number\" id=\"field1\" role=\"spinbutton\" />
        </body>
      </html>
    ")
    display = Hatemile::Implementation::AccessibleDisplayImplementation.new(
      html_parser,
      CONFIGURE
    )
    display.display_all_roles
    body = html_parser.find('body').first_result
    a = html_parser.find('a').first_result
    span = html_parser.find('span[role="note"]').first_result
    index_span = body.get_children_elements.index(span)
    label = html_parser.find('label').first_result

    assert_equal(
      '(Begin of application) ',
      body.get_first_element_child.get_text_content
    )
    assert_equal(
      ' (End of application)',
      body.get_last_element_child.get_text_content
    )
    assert_equal('(Begin of link) ', a.get_first_element_child.get_text_content)
    assert_equal(' (End of link)', a.get_last_element_child.get_text_content)
    assert_equal(
      '(Begin of note) ',
      body.get_children_elements[index_span - 1].get_text_content
    )
    assert_equal(
      ' (End of note)',
      body.get_children_elements[index_span + 1].get_text_content
    )
    assert_equal(
      '(Begin of spin button) ',
      html_parser.find(label).find_children(
        '[data-roleof]'
      ).first_result.get_text_content
    )
    assert_equal(
      ' (End of spin button)',
      html_parser.find(label).find_children(
        '[data-roleof]'
      ).last_result.get_text_content
    )
  end
end
