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

require File.join(
  File.dirname(File.dirname(__FILE__)),
  'style_sheet_declaration'
)

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
      # The Hatemile::Util::Css::Rcp module contains the implementation of CSS
      # handles for Ruby CSS Parser library.
      module Rcp
        ##
        # The RCPDeclaration class is official implementation of
        # Hatemile::Util::Css::StyleSheetDeclaration for Ruby CSS Parser.
        class RCPDeclaration < Hatemile::Util::Css::StyleSheetDeclaration
          public_class_method :new

          ##
          # Initializes a new object that encapsulate the Ruby CSS Parser
          # declaration.
          #
          # @param property_name [String] The property name of declaration.
          # @param value [String] The value of declaration.
          def initialize(property_name, value)
            @property_name = property_name
            @value = value
          end

          ##
          # @see Hatemile::Util::Css::StyleSheetDeclaration#get_value
          def get_value
            @value
          end

          ##
          # @see Hatemile::Util::Css::StyleSheetDeclaration#get_values
          def get_values
            get_value.split(/[ \n\t\r]+/)
          end

          ##
          # @see Hatemile::Util::Css::StyleSheetDeclaration#get_property
          def get_property
            @property_name
          end
        end
      end
    end
  end
end
