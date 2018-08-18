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
  'configure'
)

##
# Test methods of Hatemile::Util::Configure class.
class TestConfigure < Test::Unit::TestCase
  ##
  # Initialize common attributes used by test methods.
  def setup
    @configure = Hatemile::Util::Configure.new(
      Dir.glob(File.join(File.dirname(__FILE__), 'locale', '*.yml')),
      %i[pt-BR en-US]
    )
  end

  ##
  # Test get_parameters method
  def test_get_parameters
    parameters = @configure.get_parameters

    assert_equal(3, parameters.length)
    assert_equal('Atalhos:', parameters['text-shortcuts'])
    assert_equal('ALT', parameters['text-standart-shortcut-prefix'])
    assert_equal('Summary:', parameters['text-heading'])
  end

  ##
  # Test has_parameter? method
  def test_has_parameter
    assert(@configure.has_parameter?('text-shortcuts'))
    assert(@configure.has_parameter?('text-standart-shortcut-prefix'))
    assert(@configure.has_parameter?('text-heading'))
    assert(!@configure.has_parameter?('unknown'))
  end

  ##
  # Test get_parameter method
  def test_get_parameter
    assert_equal('Atalhos:', @configure.get_parameter('text-shortcuts'))
    assert_equal(
      'ALT',
      @configure.get_parameter(
        'text-standart-shortcut-prefix'
      )
    )
    assert_equal('Summary:', @configure.get_parameter('text-heading'))
    assert_raise do
      assert(configure.get_parameter('unknown'))
    end
  end
end
