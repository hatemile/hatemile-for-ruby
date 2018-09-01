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
# Test methods of Hatemile::Util::Css::Rcp::RCPRule class.
class TestRCPRule < Test::Unit::TestCase
  ##
  # Initialize common attributes used by test methods.
  def setup
    @css_parser = Hatemile::Util::Css::Rcp::RCPParser.new('
      #a1 {
        color: red;
      }
      #a2:hover {
        display: none;
        color: green;
      }
      #a3 #a4 {
        color: blue;
        clear: both;
      }
      #a5 #a6:active {
        width: 100px;
      }
      #a7 > #a8 {
        font-size: 1.2em;
        color: purple;
        align: center;
      }
      #a9:hover > #a10,
      #a11,
      #a12 #a13 {
        background-color: cyan;
      }
    ')
  end

  ##
  # Test has_property? method.
  def test_has_property
    rules = @css_parser.get_rules(['color', 'background-color'])

    assert(rules.first.has_property?('color'))
    assert(!rules.first.has_property?('background-color'))
    assert(!rules.last.has_property?('color'))
    assert(rules.last.has_property?('background-color'))
  end

  ##
  # Test get_declarations method.
  def test_get_declarations
    rules = @css_parser.get_rules(['color'])

    assert_equal('red', rules.first.get_declarations('color').first.get_value)
    assert_equal('purple', rules.last.get_declarations('color').first.get_value)
  end

  ##
  # Test get_selector method.
  def test_get_selector
    rules = @css_parser.get_rules(['color', 'background-color'])

    assert_equal('#a1', rules.first.get_selector)
    assert_equal('#a9:hover > #a10, #a11, #a12 #a13', rules.last.get_selector)
  end
end
