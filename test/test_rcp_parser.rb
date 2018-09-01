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
# Test methods of Hatemile::Util::Css::Rcp::RCPParser class.
class TestRCPParser < Test::Unit::TestCase
  ##
  # The CSS code used for test all methods.
  CSS_CODE = '
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
    #a9:hover > #a10 {
      background-color: cyan;
    }
  '.freeze

  ##
  # Test initialize method with CSS code argument.
  def test_initialize_with_css_code
    css_parser = Hatemile::Util::Css::Rcp::RCPParser.new(CSS_CODE)
    rules = css_parser.get_rules(['color'])

    assert_equal(4, rules.length)
  end

  ##
  # Test initialize method with HTML parser argument.
  def test_initialize_with_html_parser
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      "<!DOCTYPE html>
      <html>
        <head>
          <title>HaTeMiLe Tests</title>
          <meta charset=\"UTF-8\" />
          <style>#{CSS_CODE}</style>
        </head>
        <body>
        </body>
      </html>"
    )
    css_parser = Hatemile::Util::Css::Rcp::RCPParser.new(html_parser)
    rules = css_parser.get_rules(['color'])

    assert_equal(4, rules.length)
  end
end
