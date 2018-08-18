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
  'accessible_form_implementation'
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
# Test methods of Hatemile::Implementation::AccessibleFormImplementation class.
class TestAccessibleFormImplementation < Test::Unit::TestCase
  ##
  # The name of attribute for not modify the elements.
  DATA_IGNORE = 'data-ignoreaccessibilityfix="true"'.freeze

  ##
  # Test fix_required_fields method.
  def test_fix_required_fields
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new("
      <!DOCTYPE html>
      <html>
        <head>
			    <title>HaTeMiLe Tests</title>
			    <meta charset=\"UTF-8\" />
		    </head>
        <body>
          <label for=\"field1\">Field1</label>
          <input type=\"text\" id=\"field1\" required />
          <label for=\"field2\">Field2</label>
          <input type=\"text\" id=\"field2\" required #{DATA_IGNORE} />
          <label for=\"field3\">Field3</label>
          <input type=\"text\" id=\"field3\" />
        </body>
      </html>
    ")
    accessibleform =
      Hatemile::Implementation::AccessibleFormImplementation.new(html_parser)
    accessibleform.fix_required_fields
    field1 = html_parser.find('#field1').first_result
    field2 = html_parser.find('#field2').first_result
    field3 = html_parser.find('#field3').first_result

    assert_equal('true', field1.get_attribute('aria-required'))
    assert(!field2.has_attribute?('aria-required'))
    assert(!field3.has_attribute?('aria-required'))
  end

  ##
  # Test fix_range_fields method.
  def test_fix_range_fields
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new("
      <!DOCTYPE html>
      <html>
        <head>
			    <title>HaTeMiLe Tests</title>
			    <meta charset=\"UTF-8\" />
		    </head>
        <body>
          <label for=\"field1\">Field1</label>
          <input type=\"number\" min=\"0\" id=\"field1\" />
          <label for=\"field2\">Field2</label>
          <input type=\"range\" max=\"10\" id=\"field2\" />
          <label for=\"field3\">Field3</label>
          <input type=\"number\" min=\"1\" max=\"9\" id=\"field3\" />
          <label for=\"field4\">Field4</label>
          <input type=\"number\" id=\"field4\" />
          <label for=\"field5\">Field5</label>
          <input type=\"number\" min=\"0\" id=\"field5\" #{DATA_IGNORE} />
          <label for=\"field6\">Field6</label>
          <input type=\"number\" max=\"11\" id=\"field6\" #{DATA_IGNORE} />
        </body>
      </html>
    ")
    accessibleform =
      Hatemile::Implementation::AccessibleFormImplementation.new(html_parser)
    accessibleform.fix_range_fields
    field1 = html_parser.find('#field1').first_result
    field2 = html_parser.find('#field2').first_result
    field3 = html_parser.find('#field3').first_result
    field4 = html_parser.find('#field4').first_result
    field5 = html_parser.find('#field5').first_result
    field6 = html_parser.find('#field6').first_result

    assert_equal('0', field1.get_attribute('aria-valuemin'))
    assert_equal('10', field2.get_attribute('aria-valuemax'))
    assert_equal('1', field3.get_attribute('aria-valuemin'))
    assert_equal('9', field3.get_attribute('aria-valuemax'))
    assert(!field4.has_attribute?('aria-valuemin'))
    assert(!field4.has_attribute?('aria-valuemax'))
    assert(!field5.has_attribute?('aria-valuemin'))
    assert(!field6.has_attribute?('aria-valuemax'))
  end

  ##
  # Test fix_autocomplete_fields method.
  def test_fix_autocomplete_fields
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new("
      <!DOCTYPE html>
      <html>
        <head>
			    <title>HaTeMiLe Tests</title>
			    <meta charset=\"UTF-8\" />
		    </head>
        <body>
          <!-- Autocomplete ON -->
          <label for=\"field1\">Field1</label>
          <input type=\"text\" id=\"field1\" autocomplete=\"on\" />
          <label for=\"field2\">Field2</label>
          <textarea id=\"field2\" autocomplete=\"on\"></textarea>
          <label for=\"field3\">Field3</label>
          <input type=\"text\" id=\"field3\" list=\"datalist1\" />
          <datalist id=\"datalist1\">
            <option value=\"Value1\" />
            <option value=\"Value2\" />
            <option value=\"Value3\" />
            <option value=\"Value4\" />
          </datalist>
          <form autocomplete=\"on\" id=\"form1\">
            <label for=\"field4\">Field4</label>
            <input type=\"text\" id=\"field4\" />
            <label for=\"field5\">Field5</label>
            <textarea id=\"field5\"></textarea>
            <label for=\"field6\">Field6</label>
            <input type=\"text\" id=\"field6\" autocomplete=\"off\" />
            <label for=\"field7\">Field7</label>
            <textarea id=\"field7\" autocomplete=\"off\"></textarea>
          </form>
          <label for=\"field8\">Field8</label>
          <input type=\"text\" id=\"field8\" form=\"form1\" />
          <label for=\"field9\">Field9</label>
          <input id=\"field9\" form=\"form1\" autocomplete=\"off\" />

          <!-- Autocomplete OFF -->
          <label for=\"field10\">Field10</label>
          <input type=\"text\" id=\"field10\" autocomplete=\"off\" />
          <label for=\"field11\">Field11</label>
          <textarea id=\"field11\" autocomplete=\"off\"></textarea>
          <form autocomplete=\"off\" id=\"form2\">
            <label for=\"field12\">Field12</label>
            <input type=\"text\" id=\"field12\" />
            <label for=\"field13\">Field13</label>
            <textarea id=\"field13\"></textarea>
            <label for=\"field14\">Field14</label>
            <input type=\"text\" id=\"field14\" autocomplete=\"on\" />
            <label for=\"field15\">Field15</label>
            <textarea id=\"field15\" autocomplete=\"on\"></textarea>
            <label for=\"field16\">Field16</label>
            <input type=\"text\" id=\"field16\" list=\"datalist2\" />
            <datalist id=\"datalist2\">
              <option value=\"Value1\" />
              <option value=\"Value2\" />
              <option value=\"Value3\" />
              <option value=\"Value4\" />
            </datalist>
          </form>
          <label for=\"field17\">Field17</label>
          <input type=\"text\" id=\"field17\" form=\"form2\" />
          <label for=\"field18\">Field18</label>
          <input id=\"field18\" form=\"form2\" autocomplete=\"on\" />

          <!-- Ignore -->
          <label for=\"field19\">Field19</label>
          <input id=\"field19\" autocomplete=\"on\" #{DATA_IGNORE} />
          <label for=\"field20\">Field20</label>
          <textarea id=\"field20\" autocomplete=\"on\" #{DATA_IGNORE}>
          </textarea>
          <label for=\"field21\">Field21</label>
          <input id=\"field21\" list=\"datalist3\" #{DATA_IGNORE} />
          <datalist id=\"datalist3\">
            <option value=\"Value1\" />
            <option value=\"Value2\" />
            <option value=\"Value3\" />
            <option value=\"Value4\" />
          </datalist>
          <form autocomplete=\"on\" id=\"form3\" #{DATA_IGNORE}>
            <label for=\"field22\">Field22</label>
            <input type=\"text\" id=\"field22\" />
            <label for=\"field23\">Field23</label>
            <textarea id=\"field23\"></textarea>
            <label for=\"field24\">Field24</label>
            <input type=\"text\" id=\"field24\" autocomplete=\"off\" />
            <label for=\"field25\">Field25</label>
            <textarea id=\"field25\" autocomplete=\"off\"></textarea>
          </form>
          <label for=\"field26\">Field26</label>
          <input type=\"text\" id=\"field26\" form=\"form3\" />
          <label for=\"field27\">Field27</label>
          <input id=\"field27\" form=\"form3\" autocomplete=\"off\" />
          <label for=\"field28\">Field28</label>
          <input id=\"field28\" form=\"form3\" #{DATA_IGNORE} />
        </body>
      </html>
    ")
    accessibleform =
      Hatemile::Implementation::AccessibleFormImplementation.new(html_parser)
    accessibleform.fix_autocomplete_fields
    field1 = html_parser.find('#field1').first_result
    field2 = html_parser.find('#field2').first_result
    field3 = html_parser.find('#field3').first_result
    field4 = html_parser.find('#field4').first_result
    field5 = html_parser.find('#field5').first_result
    field6 = html_parser.find('#field6').first_result
    field7 = html_parser.find('#field7').first_result
    field8 = html_parser.find('#field8').first_result
    field9 = html_parser.find('#field9').first_result
    field10 = html_parser.find('#field10').first_result
    field11 = html_parser.find('#field11').first_result
    field12 = html_parser.find('#field12').first_result
    field13 = html_parser.find('#field13').first_result
    field14 = html_parser.find('#field14').first_result
    field15 = html_parser.find('#field15').first_result
    field16 = html_parser.find('#field16').first_result
    field17 = html_parser.find('#field17').first_result
    field18 = html_parser.find('#field18').first_result
    field19 = html_parser.find('#field19').first_result
    field20 = html_parser.find('#field20').first_result
    field21 = html_parser.find('#field21').first_result
    field22 = html_parser.find('#field22').first_result
    field23 = html_parser.find('#field23').first_result
    field24 = html_parser.find('#field24').first_result
    field25 = html_parser.find('#field25').first_result
    field26 = html_parser.find('#field26').first_result
    field27 = html_parser.find('#field27').first_result
    field28 = html_parser.find('#field28').first_result

    assert_equal('both', field1.get_attribute('aria-autocomplete'))
    assert_equal('both', field2.get_attribute('aria-autocomplete'))
    assert_equal('list', field3.get_attribute('aria-autocomplete'))
    assert_equal('both', field4.get_attribute('aria-autocomplete'))
    assert_equal('both', field5.get_attribute('aria-autocomplete'))
    assert_equal('none', field6.get_attribute('aria-autocomplete'))
    assert_equal('none', field7.get_attribute('aria-autocomplete'))
    assert_equal('both', field8.get_attribute('aria-autocomplete'))
    assert_equal('none', field9.get_attribute('aria-autocomplete'))

    assert_equal('none', field10.get_attribute('aria-autocomplete'))
    assert_equal('none', field11.get_attribute('aria-autocomplete'))
    assert_equal('none', field12.get_attribute('aria-autocomplete'))
    assert_equal('none', field13.get_attribute('aria-autocomplete'))
    assert_equal('both', field14.get_attribute('aria-autocomplete'))
    assert_equal('both', field15.get_attribute('aria-autocomplete'))
    assert_equal('list', field16.get_attribute('aria-autocomplete'))
    assert_equal('none', field17.get_attribute('aria-autocomplete'))
    assert_equal('both', field18.get_attribute('aria-autocomplete'))

    assert(!field19.has_attribute?('aria-autocomplete'))
    assert(!field20.has_attribute?('aria-autocomplete'))
    assert(!field21.has_attribute?('aria-autocomplete'))
    assert(!field22.has_attribute?('aria-autocomplete'))
    assert(!field23.has_attribute?('aria-autocomplete'))
    assert(!field24.has_attribute?('aria-autocomplete'))
    assert(!field25.has_attribute?('aria-autocomplete'))
    assert('both', field26.get_attribute('aria-autocomplete'))
    assert('none', field27.get_attribute('aria-autocomplete'))
    assert(!field28.has_attribute?('aria-autocomplete'))
  end
end
