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

require 'rexml/document'
require File.dirname(__FILE__) + '/selector_change.rb'
require File.dirname(__FILE__) + '/skipper.rb'

module Hatemile
  module Util
    ##
    # The Configure class contains the configuration of HaTeMiLe.
    class Configure
      ##
      # Initializes a new object that contains the configuration of HaTeMiLe.
      #
      # @param file_name [String] The full path of file.
      def initialize(file_name = nil)
        @parameters = {}
        @selector_changes = []
        @skippers = []
        if file_name.nil?
          file_name = File.dirname(__FILE__) + '/../../hatemile-configure.xml'
        end
        document = REXML::Document.new(File.read(file_name))
        document.elements.each('configure/parameters/parameter') do |parameter|
          if parameter.text.class != NilClass
            @parameters[parameter.attribute('name').value] = parameter.text
          else
            @parameters[parameter.attribute('name').value] = ''
          end
        end
        document.elements.each(
          'configure/selector-changes/selector-change'
        ) do |selector_change|
          @selector_changes.push(
            SelectorChange.new(
              selector_change.attribute('selector').value,
              selector_change.attribute('attribute').value,
              selector_change.attribute('value-attribute').value
            )
          )
        end
        document.elements.each('configure/skippers/skipper') do |skipper|
          @skippers.push(
            Skipper.new(
              skipper.attribute('selector').value,
              skipper.attribute('default-text').value,
              skipper.attribute('shortcut').value
            )
          )
        end
      end

      ##
      # Returns the parameters of configuration.
      #
      # @return [Hash] The parameters of configuration.
      def get_parameters
        @parameters.clone
      end

      ##
      # Returns the value of a parameter of configuration.
      #
      # @param parameter [String] The parameter.
      # @return [String] The value of the parameter.
      def get_parameter(parameter)
        @parameters[parameter]
      end

      ##
      # Returns the changes that will be done in selectors.
      #
      # @return [Array<SelectorChange>] The changes that will be done in
      #   selectors.
      def get_selector_changes
        @selector_changes.clone
      end

      ##
      # Returns the skippers.
      #
      # @return [Array<Skipper>] The skippers.
      def get_skippers
        @skippers.clone
      end
    end
  end
end
