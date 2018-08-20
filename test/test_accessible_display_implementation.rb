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
  # Test fix_shortcuts method with container of shorcuts not defined.
  def test_fix_shortcuts_container_not_defined
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
    display.fix_shortcuts
    accesskey_r = html_parser.find('[accesskey="r"]').first_result
    accesskey_w = html_parser.find('[accesskey="w"]').first_result
    accesskey_f = html_parser.find('[accesskey="f"]').first_result
    accesskey_s = html_parser.find('[accesskey="s"]').first_result
    accesskey_i = html_parser.find('[accesskey="i"]').first_result
    reference_r = html_parser.find(
      '[data-shortcutdescriptionfor="R"]'
    ).first_result
    reference_w = html_parser.find(
      '[data-shortcutdescriptionfor="W"]'
    ).first_result
    reference_f = html_parser.find(
      '[data-shortcutdescriptionfor="F"]'
    ).first_result
    reference_s = html_parser.find(
      '[data-shortcutdescriptionfor="S"]'
    ).first_result
    reference_i = html_parser.find(
      '[data-shortcutdescriptionfor="I"]'
    ).first_result

    assert_not_nil(html_parser.find('#container-shortcuts').first_result)
    assert_equal('HaTeMiLe in Github', accesskey_r.get_attribute('title'))
    assert_equal('Site', accesskey_w.get_attribute('title'))
    assert_equal('Field1', accesskey_f.get_attribute('title'))
    assert_equal('Submit', accesskey_s.get_attribute('title'))
    assert(!accesskey_i.has_attribute?('title'))
    assert_equal('ALT + R: HaTeMiLe in Github', reference_r.get_text_content)
    assert_equal('ALT + W: Site', reference_w.get_text_content)
    assert_equal('ALT + F: Field1', reference_f.get_text_content)
    assert_equal('ALT + S: Submit', reference_s.get_text_content)
    assert_nil(reference_i)
  end

  ##
  # Test fix_shortcuts method with container of shortcuts defined.
  def test_fix_shortcuts_container_defined
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new("
      <!DOCTYPE html>
      <html>
        <head>
			    <title>HaTeMiLe Tests</title>
			    <meta charset=\"UTF-8\" />
		    </head>
        <body>
          <div id=\"container-shortcuts\"></div>
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
    display.fix_shortcuts
    accesskey_r = html_parser.find('[accesskey="r"]').first_result
    accesskey_w = html_parser.find('[accesskey="w"]').first_result
    accesskey_f = html_parser.find('[accesskey="f"]').first_result
    accesskey_s = html_parser.find('[accesskey="s"]').first_result
    accesskey_i = html_parser.find('[accesskey="i"]').first_result
    reference_r = html_parser.find(
      '#container-shortcuts [data-shortcutdescriptionfor="R"]'
    ).first_result
    reference_w = html_parser.find(
      '#container-shortcuts [data-shortcutdescriptionfor="W"]'
    ).first_result
    reference_f = html_parser.find(
      '#container-shortcuts [data-shortcutdescriptionfor="F"]'
    ).first_result
    reference_s = html_parser.find(
      '#container-shortcuts [data-shortcutdescriptionfor="S"]'
    ).first_result
    reference_i = html_parser.find(
      '#container-shortcuts [data-shortcutdescriptionfor="I"]'
    ).first_result

    assert_equal(
      'container-shortcuts',
      html_parser.find(
        'body'
      ).first_result.get_first_element_child.get_attribute('id')
    )
    assert_equal('HaTeMiLe in Github', accesskey_r.get_attribute('title'))
    assert_equal('Site', accesskey_w.get_attribute('title'))
    assert_equal('Field1', accesskey_f.get_attribute('title'))
    assert_equal('Submit', accesskey_s.get_attribute('title'))
    assert(!accesskey_i.has_attribute?('title'))
    assert_equal('ALT + R: HaTeMiLe in Github', reference_r.get_text_content)
    assert_equal('ALT + W: Site', reference_w.get_text_content)
    assert_equal('ALT + F: Field1', reference_f.get_text_content)
    assert_equal('ALT + S: Submit', reference_s.get_text_content)
    assert_nil(reference_i)
  end
end
