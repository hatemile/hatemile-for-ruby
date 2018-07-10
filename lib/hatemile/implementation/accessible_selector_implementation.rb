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

require File.dirname(__FILE__) + '/../accessible_selector.rb'

module Hatemile
  module Implementation
    ##
    # The AccessibleSelectorImplementation class is official implementation of
    # AccessibleSelector interface.
    class AccessibleSelectorImplementation < AccessibleSelector
      public_class_method :new

      ##
      # Initializes a new object that manipulate the accessibility through of
      # the selectors of the configuration file.
      #
      # @param parser [Hatemile::Util::HTMLDOMParser] The HTML parser.
      # @param configure [Hatemile::Util::Configure] The configuration of
      #   HaTeMiLe.
      def initialize(parser, configure)
        @parser = parser
        @changes = configure.get_selector_changes
        @data_ignore = 'data-ignoreaccessibilityfix'
      end

      def fix_selectors
        @changes.each do |change|
          elements = @parser.find(change.get_selector).list_results
          elements.each do |element|
            next if element.has_attribute?(@data_ignore)

            element.set_attribute(
              change.get_attribute,
              change.get_value_for_attribute
            )
          end
        end
      end
    end
  end
end
