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
  'accessible_css_implementation'
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
require File.join(
  File.dirname(File.dirname(__FILE__)),
  'lib',
  'hatemile',
  'util',
  'css',
  'rcp',
  'rcp_parser'
)

##
# Test methods of Hatemile::Implementation::AccessibleCSSImplementation class.
class TestAccessibleCSSImplementation < Test::Unit::TestCase
  ##
  # The name of attribute for not modify the elements.
  DATA_IGNORE = 'data-ignoreaccessibilityfix="true"'.freeze
  ##
  # Initialize common attributes used by test methods.
  def setup
    @configure = Hatemile::Util::Configure.new
  end

  ##
  # Test "speak: none" declaration.
  def test_speak_none
    style = "#speak-none-local,
      #speak-none-inherit,
      #speak-none-local-ignore,
      #speak-none-inherit-ignore {
        speak: none;
      }"
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      "<!DOCTYPE html>
      <html>
        <head>
          <title>HaTeMiLe Tests</title>
          <meta charset=\"UTF-8\" />
        </head>
        <body>
          <span id=\"speak-none-local\">Not speak this text.</span>
          <div id=\"speak-none-inherit\">
            Not speak <strong>this text.</strong>
          </div>
          <span id=\"speak-none-local-ignore\" #{DATA_IGNORE}>
            Not speak this text.
          </span>
          <div id=\"speak-none-inherit-ignore\" #{DATA_IGNORE}>
            Not speak <strong>this text.</strong>
          </div>
        </body>
      </html>"
    )
    css_parser = Hatemile::Util::Css::Rcp::RCPParser.new(style)
    css = Hatemile::Implementation::AccessibleCSSImplementation.new(
      html_parser,
      css_parser,
      @configure
    )
    css.provide_all_speak_properties
    speak_none_local = html_parser.find('#speak-none-local').first_result
    speak_none_inherit = html_parser.find('#speak-none-inherit').first_result
    speak_none_local_ignore = html_parser.find(
      '#speak-none-local-ignore'
    ).first_result

    assert(speak_none_local.has_attribute?('role'))
    assert_equal('presentation', speak_none_local.get_attribute('role'))
    assert(speak_none_local.has_attribute?('aria-hidden'))
    assert_equal('true', speak_none_local.get_attribute('aria-hidden'))

    speak_none_inherit.get_children_elements.each do |child|
      assert(child.has_attribute?('role'))
      assert_equal('presentation', child.get_attribute('role'))
      assert(child.has_attribute?('aria-hidden'))
      assert_equal('true', child.get_attribute('aria-hidden'))
    end

    assert(!speak_none_local_ignore.has_attribute?('role'))
    assert(!speak_none_local_ignore.has_attribute?('aria-hidden'))
    assert_nil(
      html_parser.find('#speak-none-inherit-ignore [role]').first_result
    )
    assert_nil(
      html_parser.find('#speak-none-inherit-ignore [aria-hidden]').first_result
    )
  end

  ##
  # Test "speak: normal" declaration.
  def test_speak_normal
    style = "#speak-none-local,
      #speak-none-inherit,
      #speak-none-local-ignore,
      #speak-none-inherit-ignore {
        speak: none;
      }
      span, div {
        speak: normal;
      }"
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      "<!DOCTYPE html>
      <html>
        <head>
          <title>HaTeMiLe Tests</title>
          <meta charset=\"UTF-8\" />
        </head>
        <body>
          <span id=\"speak-none-local\">Speak this text.</span>
          <div id=\"speak-none-inherit\">
            Speak <strong>this text.</strong>
          </div>
          <span id=\"speak-none-local-ignore\" #{DATA_IGNORE}>
            Speak this text.
          </span>
          <div id=\"speak-none-inherit-ignore\" #{DATA_IGNORE}>
            Speak <strong>this text.</strong>
          </div>
        </body>
      </html>"
    )
    css_parser = Hatemile::Util::Css::Rcp::RCPParser.new(style)
    css = Hatemile::Implementation::AccessibleCSSImplementation.new(
      html_parser,
      css_parser,
      @configure
    )
    css.provide_all_speak_properties

    assert_nil(html_parser.find('body [role]').first_result)
    assert_nil(html_parser.find('body [aria-hidden]').first_result)
  end

  ##
  # Test "speak-as: spell-out" declaration.
  def test_speak_as_spell_out
    style = "#speak-as-spell-out-local,
      #speak-as-spell-out-inherit,
      #speak-as-spell-out-local-ignore,
      #speak-as-spell-out-inherit-ignore {
        speak-as: spell-out;
      }"
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      "<!DOCTYPE html>
      <html>
        <head>
          <title>HaTeMiLe Tests</title>
          <meta charset=\"UTF-8\" />
        </head>
        <body>
          <span id=\"speak-as-spell-out-local\">Speak this text.</span>
          <div id=\"speak-as-spell-out-inherit\">
            Speak <strong>this text.</strong>
          </div>
          <span id=\"speak-as-spell-out-local-ignore\" #{DATA_IGNORE}>
            Speak this text.
          </span>
          <div id=\"speak-as-spell-out-inherit-ignore\" #{DATA_IGNORE}>
            Speak <strong>this text.</strong>
          </div>
        </body>
      </html>"
    )
    css_parser = Hatemile::Util::Css::Rcp::RCPParser.new(style)
    css = Hatemile::Implementation::AccessibleCSSImplementation.new(
      html_parser,
      css_parser,
      @configure
    )
    css.provide_all_speak_properties
    speak_as_spell_out_local = html_parser.find(
      '#speak-as-spell-out-local'
    ).first_result
    speak_as_spell_out_inherit = html_parser.find(
      '#speak-as-spell-out-inherit'
    ).first_result
    speak_as_spell_out_local_ignore = html_parser.find(
      '#speak-as-spell-out-local-ignore'
    ).first_result
    speak_as_spell_out_inherit_ignore = html_parser.find(
      '#speak-as-spell-out-inherit-ignore'
    ).first_result

    assert_equal(
      'S p e a k  t h i s  t e x t .',
      speak_as_spell_out_local.get_text_content
    )
    assert_equal(
      'S p e a k  t h i s  t e x t .',
      speak_as_spell_out_inherit.get_text_content.strip
    )
    assert_equal(
      'Speak this text.',
      speak_as_spell_out_local_ignore.get_text_content.strip
    )
    assert_equal(
      'Speak this text.',
      speak_as_spell_out_inherit_ignore.get_text_content.strip
    )
  end

  ##
  # Test "speak-as: literal-punctuation" declaration.
  def test_speak_as_literal_punctuation
    style = "#speak-as-lp-local,
      #speak-as-lp-inherit,
      #speak-as-lp-local-ignore,
      #speak-as-lp-inherit-ignore {
        speak-as: literal-punctuation;
      }"
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      "<!DOCTYPE html>
      <html>
        <head>
          <title>HaTeMiLe Tests</title>
          <meta charset=\"UTF-8\" />
        </head>
        <body>
          <span id=\"speak-as-lp-local\">Speak this text.</span>
          <div id=\"speak-as-lp-inherit\">
            Speak <strong>this text.</strong>
          </div>
          <span id=\"speak-as-lp-local-ignore\" #{DATA_IGNORE}>
            Speak this text.
          </span>
          <div id=\"speak-as-lp-inherit-ignore\" #{DATA_IGNORE}>
            Speak <strong>this text.</strong>
          </div>
        </body>
      </html>"
    )
    css_parser = Hatemile::Util::Css::Rcp::RCPParser.new(style)
    css = Hatemile::Implementation::AccessibleCSSImplementation.new(
      html_parser,
      css_parser,
      @configure
    )
    css.provide_all_speak_properties
    speak_as_lp_local = html_parser.find('#speak-as-lp-local').first_result
    speak_as_lp_inherit = html_parser.find('#speak-as-lp-inherit').first_result
    speak_as_lp_local_ignore = html_parser.find(
      '#speak-as-lp-local-ignore'
    ).first_result
    speak_as_lp_inherit_ignore = html_parser.find(
      '#speak-as-lp-inherit-ignore'
    ).first_result

    assert_equal(
      'Speak this text Dot .',
      speak_as_lp_local.get_text_content
    )
    assert_equal(
      'Speak this text Dot .',
      speak_as_lp_inherit.get_text_content.strip
    )
    assert_equal(
      'Speak this text.',
      speak_as_lp_local_ignore.get_text_content.strip
    )
    assert_equal(
      'Speak this text.',
      speak_as_lp_inherit_ignore.get_text_content.strip
    )
  end

  ##
  # Test "speak-as: no-punctuation" declaration.
  def test_speak_as_no_punctuation
    style = "#speak-as-np-local,
      #speak-as-np-inherit,
      #speak-as-np-local-ignore,
      #speak-as-np-inherit-ignore {
        speak-as: no-punctuation;
      }"
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      "<!DOCTYPE html>
      <html>
        <head>
          <title>HaTeMiLe Tests</title>
          <meta charset=\"UTF-8\" />
        </head>
        <body>
          <span id=\"speak-as-np-local\">Speak this text.</span>
          <div id=\"speak-as-np-inherit\">
            Speak <strong>this text.</strong>
          </div>
          <span id=\"speak-as-np-local-ignore\" #{DATA_IGNORE}>
            Speak this text.
          </span>
          <div id=\"speak-as-np-inherit-ignore\" #{DATA_IGNORE}>
            Speak <strong>this text.</strong>
          </div>
        </body>
      </html>"
    )
    css_parser = Hatemile::Util::Css::Rcp::RCPParser.new(style)
    css = Hatemile::Implementation::AccessibleCSSImplementation.new(
      html_parser,
      css_parser,
      @configure
    )
    css.provide_all_speak_properties

    assert_equal(
      '.',
      html_parser.find(
        '#speak-as-np-local [aria-hidden]'
      ).first_result.get_text_content
    )
    assert_equal(
      '.',
      html_parser.find(
        '#speak-as-np-inherit [aria-hidden]'
      ).first_result.get_text_content.strip
    )
    assert_nil(
      html_parser.find('#speak-as-np-local-ignore [aria-hidden]').first_result
    )
    assert_nil(
      html_parser.find('#speak-as-np-inherit-ignore [aria-hidden]').first_result
    )
  end

  ##
  # Test "speak-as: digits" declaration.
  def test_speak_as_digits
    style = "#speak-as-digits-local,
      #speak-as-digits-inherit,
      #speak-as-digits-local-ignore,
      #speak-as-digits-inherit-ignore {
        speak-as: digits;
      }"
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      "<!DOCTYPE html>
      <html>
        <head>
          <title>HaTeMiLe Tests</title>
          <meta charset=\"UTF-8\" />
        </head>
        <body>
          <span id=\"speak-as-digits-local\">111</span>
          <div id=\"speak-as-digits-inherit\">
            123 <strong>456</strong>
          </div>
          <span id=\"speak-as-digits-local-ignore\" #{DATA_IGNORE}>777</span>
          <div id=\"speak-as-digits-inherit-ignore\" #{DATA_IGNORE}>
            888 <strong>999</strong>
          </div>
        </body>
      </html>"
    )
    css_parser = Hatemile::Util::Css::Rcp::RCPParser.new(style)
    css = Hatemile::Implementation::AccessibleCSSImplementation.new(
      html_parser,
      css_parser,
      @configure
    )
    css.provide_all_speak_properties
    speak_as_digits_local = html_parser.find(
      '#speak-as-digits-local'
    ).first_result
    speak_as_digits_inherit = html_parser.find(
      '#speak-as-digits-inherit'
    ).first_result
    speak_as_digits_local_ignore = html_parser.find(
      '#speak-as-digits-local-ignore'
    ).first_result
    speak_as_digits_inherit_ignore = html_parser.find(
      '#speak-as-digits-inherit-ignore'
    ).first_result

    assert_equal('1 1 1', speak_as_digits_local.get_text_content.strip)
    assert_equal(
      '1 2 3  4 5 6',
      speak_as_digits_inherit.get_text_content.strip
    )
    assert_equal('777', speak_as_digits_local_ignore.get_text_content.strip)
    assert_equal(
      '888 999',
      speak_as_digits_inherit_ignore.get_text_content.strip
    )
  end

  ##
  # Test "speak-as: normal" declaration.
  def test_speak_as_normal
    style = "#speak-as-spell-out-local,
      #speak-as-spell-out-inherit,
      #speak-as-spell-out-local-ignore,
      #speak-as-spell-out-inherit-ignore {
        speak-as: spell-out;
      }
      #speak-as-lp-local,
      #speak-as-lp-inherit,
      #speak-as-lp-local-ignore,
      #speak-as-lp-inherit-ignore {
        speak-as: literal-punctuation;
      }
      #speak-as-np-local,
      #speak-as-np-inherit,
      #speak-as-np-local-ignore,
      #speak-as-np-inherit-ignore {
        speak-as: no-punctuation;
      }
      #speak-as-digits-local,
      #speak-as-digits-inherit,
      #speak-as-digits-local-ignore,
      #speak-as-digits-inherit-ignore {
        speak-as: digits;
      }
      span, div {
        speak-as: normal;
      }"
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      "<!DOCTYPE html>
      <html>
        <head>
          <title>HaTeMiLe Tests</title>
          <meta charset=\"UTF-8\" />
        </head>
        <body>
          <span id=\"speak-as-spell-out-local\">Speak this text.</span>
          <div id=\"speak-as-spell-out-inherit\">
            Speak <strong>this text.</strong>
          </div>
          <span id=\"speak-as-lp-local\">Speak this text.</span>
          <div id=\"speak-as-lp-inherit\">
            Speak <strong>this text.</strong>
          </div>
          <span id=\"speak-as-np-local\">Speak this text.</span>
          <div id=\"speak-as-np-inherit\">
            Speak <strong>this text.</strong>
          </div>
          <span id=\"speak-as-digits-local\">111</span>
          <div id=\"speak-as-digits-inherit\">
            123 <strong>456</strong>
          </div>
        </body>
      </html>"
    )
    css_parser = Hatemile::Util::Css::Rcp::RCPParser.new(style)
    css = Hatemile::Implementation::AccessibleCSSImplementation.new(
      html_parser,
      css_parser,
      @configure
    )
    css.provide_all_speak_properties
    speak_as_spell_out_local = html_parser.find(
      '#speak-as-spell-out-local'
    ).first_result
    speak_as_spell_out_inherit = html_parser.find(
      '#speak-as-spell-out-inherit'
    ).first_result
    speak_as_lp_local = html_parser.find('#speak-as-lp-local').first_result
    speak_as_lp_inherit = html_parser.find('#speak-as-lp-inherit').first_result
    speak_as_digits_local = html_parser.find(
      '#speak-as-digits-local'
    ).first_result
    speak_as_digits_inherit = html_parser.find(
      '#speak-as-digits-inherit'
    ).first_result

    assert_equal('Speak this text.', speak_as_spell_out_local.get_text_content)
    assert_equal(
      'Speak this text.',
      speak_as_spell_out_inherit.get_text_content.strip
    )
    assert_equal('Speak this text.', speak_as_lp_local.get_text_content.strip)
    assert_equal('Speak this text.', speak_as_lp_inherit.get_text_content.strip)
    assert_nil(
      html_parser.find('#speak-as-np-local [aria-hidden]').first_result
    )
    assert_nil(
      html_parser.find('#speak-as-np-inherit [aria-hidden]').first_result
    )
    assert_equal('111', speak_as_digits_local.get_text_content)
    assert_equal('123 456', speak_as_digits_inherit.get_text_content.strip)
  end
end
