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

##
# The Hatemile module contains the interfaces with the acessibility solutions.
module Hatemile
  ##
  # The Hatemile::Implementation module contains the official implementation of
  # interfaces solutions.
  module Implementation
    ##
    # The AccessibleSelectorImplementation class is official implementation of
    # AccessibleSelector interface.
    class AccessibleSelectorImplementation < AccessibleSelector
      public_class_method :new

      ##
      # The name of attribute for not modify the elements.
      DATA_IGNORE = 'data-ignoreaccessibilityfix'.freeze

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
      end

      ##
      # @see Hatemile::AccessibleSelector#fix_selectors
      def fix_selectors
        @changes.each do |change|
          elements = @parser.find(change.get_selector).list_results
          elements.each do |element|
            next if element.has_attribute?(DATA_IGNORE)

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
