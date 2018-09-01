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
      # The StyleSheetDeclaration interface contains the methods for access the
      # CSS declaration.
      #
      # @abstract
      class StyleSheetDeclaration
        private_class_method :new

        ##
        # Returns the value of declaration.
        #
        # @abstract
        # @return [String] The value of declaration.
        def get_value
          # Interface method
        end

        ##
        # Returns a list with the values of declaration.
        #
        # @abstract
        # @return [Array<String>] The list with the values of declaration.
        def get_values
          # Interface method
        end

        ##
        # Returns the property of declaration.
        #
        # @abstract
        # @return [String] The property of declaration.
        def get_property
          # Interface method
        end
      end
    end
  end
end
