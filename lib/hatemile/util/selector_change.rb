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

module Hatemile
  module Util
    ##
    # The SelectorChange class store the selector that be attribute change.
    class SelectorChange
      ##
      # Inicializes a new object with the values pre-defineds.
      #
      # ---
      #
      # Parameters:
      #  1. String +selector+ The selector.
      #  2. String +attribute+ The attribute.
      #  3. String +valueForAttribute+ The value of the attribute.
      def initialize(selector, attribute, valueForAttribute)
        @selector = selector
        @attribute = attribute
        @valueForAttribute = valueForAttribute
      end

      ##
      # Returns the selector.
      #
      # ---
      #
      # Return:
      # String The selector.
      def getSelector
        @selector
      end

      ##
      # Returns the attribute.
      #
      # ---
      #
      # Return:
      # String The attribute.
      def getAttribute
        @attribute
      end

      ##
      # Returns the value of the attribute.
      #
      # ---
      #
      # Return:
      # String The value of the attribute.
      def getValueForAttribute
        @valueForAttribute
      end
    end
  end
end
