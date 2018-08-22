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
  'util',
  'common_functions'
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
# Test methods of Hatemile::Util::CommonFunctions class.
class TestCommonFunctions < Test::Unit::TestCase
  ##
  # Test increase_in_list method.
  def test_increase_in_list
    assert_equal(
      'item',
      Hatemile::Util::CommonFunctions.increase_in_list(nil, 'item')
    )
    assert_equal(
      'item',
      Hatemile::Util::CommonFunctions.increase_in_list('item', nil)
    )
    assert_equal(
      'item',
      Hatemile::Util::CommonFunctions.increase_in_list('', 'item')
    )
    assert_equal(
      'item',
      Hatemile::Util::CommonFunctions.increase_in_list('item', '')
    )
    assert_equal(
      'item1 item2 item',
      Hatemile::Util::CommonFunctions.increase_in_list('item1 item2', 'item')
    )
  end

  ##
  # Test in_list? method.
  def test_in_list
    assert(!Hatemile::Util::CommonFunctions.in_list?(nil, 'item'))
    assert(!Hatemile::Util::CommonFunctions.in_list?('item', nil))
    assert(!Hatemile::Util::CommonFunctions.in_list?('', 'item'))
    assert(!Hatemile::Util::CommonFunctions.in_list?('item', ''))
    assert(!Hatemile::Util::CommonFunctions.in_list?('item1 item2', 'item'))
    assert(Hatemile::Util::CommonFunctions.in_list?('item1 item2', 'item1'))
    assert(Hatemile::Util::CommonFunctions.in_list?('item1 item2', 'item2'))
  end

  ##
  # Test is_valid_element? method.
  def test_is_valid_element
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new('
      <!DOCTYPE html>
      <html>
        <head>
          <title>HaTeMiLe Tests</title>
          <meta charset=\"UTF-8\" />
        </head>
        <body>
          <table>
            <thead>
              <tr>
                <th>Column</th>
              </tr>
            </thead>
            <tbody data-ignoreaccessibilityfix="true">
              <tr>
                <td>Cell</td>
              </tr>
            </tbody>
          </table>
        </body>
      </html>
    ')

    assert(
      Hatemile::Util::CommonFunctions.is_valid_element?(
        html_parser.find('table').first_result
      )
    )
    assert(
      Hatemile::Util::CommonFunctions.is_valid_element?(
        html_parser.find('th').first_result
      )
    )
    assert(
      !Hatemile::Util::CommonFunctions.is_valid_element?(
        html_parser.find('tbody').first_result
      )
    )
    assert(
      !Hatemile::Util::CommonFunctions.is_valid_element?(
        html_parser.find('tr').last_result
      )
    )
    assert(
      !Hatemile::Util::CommonFunctions.is_valid_element?(
        html_parser.find('td').first_result
      )
    )
  end
end
