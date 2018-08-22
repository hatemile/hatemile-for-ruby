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
  'accessible_association_implementation'
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
# Test methods of Hatemile::Implementation::AccessibleAssociationImplementation
# class.
class TestAccessibleAssociationImplementation < Test::Unit::TestCase
  ##
  # The name of attribute for not modify the elements.
  DATA_IGNORE = 'data-ignoreaccessibilityfix="true"'.freeze

  ##
  # Initialize common attributes used by test methods.
  def setup
    @html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      "<!DOCTYPE html>
      <html>
        <head>
          <title>HaTeMiLe Tests</title>
          <meta charset=\"UTF-8\" />
        </head>
        <body>
          <table id=\"table1\">
            <thead>
              <tr>
                <th rowspan=\"2\" data-id=\"t1column11\">Column 1.1</th>
                <th id=\"t1column12\">Column 1.2</th>
                <th id=\"t1column13\" #{DATA_IGNORE}>Column 1.3</th>
                <td id=\"t1column14\">Column 1.4</td>
              </tr>
              <tr>
                <th id=\"t1column22\">Column 2.2</th>
                <th colspan=\"2\" id=\"t1column23\">Column 2.3</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <th rowspan=\"2\" id=\"t1cell11\">Cell 1.1</th>
                <td id=\"t1cell12\" #{DATA_IGNORE}>Cell 1.2</td>
                <td data-id=\"t1cell13\">Cell 1.3</td>
                <td id=\"t1cell14\">Cell 1.4</td>
              </tr>
              <tr>
                <td colspan=\"3\" id=\"t1cell22\">Cell 2.2</td>
              </tr>
            </tbody>
          </table>
          <table id=\"table2\">
            <thead>
              <tr>
                <th rowspan=\"2\" id=\"t2column11\">Column 1.1</th>
                <th id=\"t2column12\">Column 1.2</th>
                <th id=\"t2column13\">Column 1.3</th>
              </tr>
              <tr>
                <th id=\"t2column22\">Column 2.2</th>
                <th colspan=\"2\" id=\"t2column23\">Column 2.3</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td rowspan=\"2\" id=\"t2cell11\">Cell 1.1</th>
                <td id=\"t2cell12\">Cell 1.2</td>
                <td id=\"t2cell13\">Cell 1.3</td>
                <td id=\"t2cell14\">Cell 1.4</td>
              </tr>
              <tr>
                <td colspan=\"3\" id=\"t2cell22\">Cell 2.2</td>
              </tr>
            </tbody>
          </table>
          <table id=\"table3\">
              <tr>
                <th rowspan=\"2\" id=\"t3column11\">Column 1.1</th>
                <th id=\"t3column12\">Column 1.2</th>
                <th id=\"t3column13\">Column 1.3</th>
                <td id=\"t3column14\">Column 1.4</td>
              </tr>
              <tr>
                <th id=\"t3column22\">Column 2.2</th>
                <th colspan=\"2\" id=\"t3column23\">Column 2.3</th>
              </tr>
              <tr>
                <th rowspan=\"2\" id=\"t3cell11\">Cell 1.1</th>
                <td id=\"t3cell12\">Cell 1.2</td>
                <td id=\"t3cell13\">Cell 1.3</td>
                <td id=\"t3cell14\">Cell 1.4</td>
              </tr>
              <tr>
                <td colspan=\"3\" id=\"t3cell22\">Cell 2.2</td>
              </tr>
          </table>
          <label for=\"field1\">Field1</label>
          <input id=\"field1\" type=\"text\" />
          <br />
          <label>
            Field2
            <input name=\"field2\" type=\"text\" />
          </label>
          <br />
          <label for=\"field3\">Field3</label>
          <input id=\"field3\" type=\"text\" aria-label=\"Field 3\" />
          <br />
          <label>Field4</label>
          <input id=\"field4\" type=\"text\" />
          <br />
          <label #{DATA_IGNORE} for=\"field5\">Field5</label>
          <input id=\"field5\" type=\"text\" />
          <br />
          <label for=\"field6\">Field6</label>
          <input id=\"field6\" type=\"text\" #{DATA_IGNORE} />
          <br />
          <div #{DATA_IGNORE}>
            <label for=\"field7\">Field7</label>
            <input id=\"field7\" type=\"text\" />
          </div>
        </body>
      </html>"
    )
    @association =
      Hatemile::Implementation::AccessibleAssociationImplementation.new(
        @html_parser
      )
  end

  ##
  # Test associate_all_data_cells_with_header_cells method.
  def test_associate_all_data_cells_with_header_cells
    @association.associate_all_data_cells_with_header_cells
    t1column11 = @html_parser.find('[data-id=t1column11]').first_result
    t1column12 = @html_parser.find('#t1column12').first_result
    t1column13 = @html_parser.find('#t1column13').first_result
    t1column14 = @html_parser.find('#t1column14').first_result
    t1column22 = @html_parser.find('#t1column22').first_result
    t1column23 = @html_parser.find('#t1column23').first_result
    t1cell11 = @html_parser.find('#t1cell11').first_result
    t1cell12 = @html_parser.find('#t1cell12').first_result
    t1cell13 = @html_parser.find('[data-id=t1cell13]').first_result
    t1cell14 = @html_parser.find('#t1cell14').first_result
    t1cell22 = @html_parser.find('#t1cell22').first_result

    assert(t1column11.has_attribute?('scope'))
    assert(t1column12.has_attribute?('scope'))
    assert(!t1column13.has_attribute?('scope'))
    assert(!t1column14.has_attribute?('scope'))
    assert(t1column22.has_attribute?('scope'))
    assert(t1column23.has_attribute?('scope'))
    assert(t1cell11.has_attribute?('scope'))
    assert(!t1cell12.has_attribute?('scope'))
    assert_equal('col', t1column11.get_attribute('scope'))
    assert_equal('col', t1column12.get_attribute('scope'))
    assert_equal('col', t1column22.get_attribute('scope'))
    assert_equal('col', t1column23.get_attribute('scope'))
    assert_equal('row', t1cell11.get_attribute('scope'))
    assert_equal(
      t1column11.get_attribute('id'),
      t1cell11.get_attribute('headers')
    )
    assert(!t1cell12.has_attribute?('headers'))
    assert_equal(
      %w[t1column23 t1cell11].to_set,
      t1cell13.get_attribute('headers').split.to_set
    )
    assert_equal(
      %w[t1column23 t1cell11].to_set,
      t1cell14.get_attribute('headers').split.to_set
    )
    assert_equal(
      %w[t1column12 t1column22 t1column23 t1cell11].to_set,
      t1cell22.get_attribute('headers').split.to_set
    )

    assert_nil(@html_parser.find('#table2 [headers]').first_result)
    assert_nil(@html_parser.find('#table3 [headers]').first_result)
  end

  ##
  # Test associate_all_labels_with_fields method.
  def test_associate_all_labels_with_fields
    field1 = @html_parser.find('#field1').first_result
    field2 = @html_parser.find('[name="field2"]').first_result
    field3 = @html_parser.find('#field3').first_result
    field4 = @html_parser.find('#field4').first_result
    field5 = @html_parser.find('#field5').first_result
    field6 = @html_parser.find('#field6').first_result
    field7 = @html_parser.find('#field7').first_result

    @association.associate_all_labels_with_fields

    label1 = @html_parser.find(
      "##{field1.get_attribute('aria-labelledby')}"
    ).first_result
    label2 = @html_parser.find(
      "##{field2.get_attribute('aria-labelledby')}"
    ).first_result
    label3 = @html_parser.find(
      "##{field3.get_attribute('aria-labelledby')}"
    ).first_result

    assert(field1.has_attribute?('aria-label'))
    assert(field1.has_attribute?('aria-labelledby'))
    assert_equal('Field1', field1.get_attribute('aria-label'))
    assert_equal('field1', label1.get_attribute('for'))

    assert(field2.has_attribute?('aria-label'))
    assert(field2.has_attribute?('aria-labelledby'))
    assert_equal('Field2', field2.get_attribute('aria-label'))
    assert_equal(
      field2,
      @html_parser.find("##{label2.get_attribute('for')}").first_result
    )

    assert(field3.has_attribute?('aria-label'))
    assert(field3.has_attribute?('aria-labelledby'))
    assert_equal('Field 3', field3.get_attribute('aria-label'))
    assert_equal('field3', label3.get_attribute('for'))

    assert(!field4.has_attribute?('aria-label'))
    assert(!field4.has_attribute?('aria-labelledby'))
    assert(!field5.has_attribute?('aria-label'))
    assert(!field5.has_attribute?('aria-labelledby'))
    assert(!field6.has_attribute?('aria-label'))
    assert(!field6.has_attribute?('aria-labelledby'))
    assert(!field7.has_attribute?('aria-label'))
    assert(!field7.has_attribute?('aria-labelledby'))
  end
end
