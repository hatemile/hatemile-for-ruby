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

##
# The Hatemile module contains the interfaces with the acessibility solutions.
module Hatemile
  ##
  # The Hatemile::Util module contains the utilities of library.
  module Util
    ##
    # The Hatemile::Util::Css module contains the interfaces of CSS handles.
    module Css
      ##
      # The StyleSheetRule interface contains the methods for access the CSS
      # rule.
      #
      # @abstract
      class StyleSheetRule
        private_class_method :new

        ##
        # Returns that the rule has a declaration with the property.
        #
        # @abstract
        # @param property_name [String] The name of property.
        # @return [Boolean] True if the rule has a declaration with the property
        #   or false if the rule not has a declaration with the property.
        def has_property?(property_name)
          # Interface method
        end

        ##
        # Returns that the rule has declarations.
        #
        # @abstract
        # @return [Boolean] True if the rule has the property or False if the
        #   rule not has declarations.
        def has_declarations?
          # Interface method
        end

        ##
        # Returns the declarations with the property.
        #
        # @abstract
        # @param property_name [String] The property.
        # @return [Hatemile::Util::Css::StyleSheetDeclaration] The declarations
        #   with the property.
        def get_declarations(property_name)
          # Interface method
        end

        ##
        # Returns the selector of rule.
        #
        # @abstract
        # @return [String] The selector of rule.
        def get_selector
          # Interface method
        end
      end
    end
  end
end
