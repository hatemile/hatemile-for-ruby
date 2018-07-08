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
    # The Skipper class store the selector that will be add a skipper.
    class Skipper
      ##
      # Inicializes a new object with the values pre-defineds.
      #
      # ---
      #
      # Parameters:
      #  1. String +selector+ The selector.
      #  2. String +default_text+ The default text of skipper.
      #  3. String +shortcuts+ The shortcuts of skipper.
      def initialize(selector, default_text, shortcuts)
        @selector = selector
        @default_text = default_text
        @shortcuts = if shortcuts.empty?
                       []
                     else
                       shortcuts.split(/[ \n\t\r]+/)
                     end
      end

      ##
      # Returns the selector.
      #
      # ---
      #
      # Return:
      # String The selector.
      def get_selector
        @selector
      end

      ##
      # Returns the default text of skipper.
      #
      # ---
      #
      # Return:
      # String The default text of skipper.
      def get_default_text
        @default_text
      end

      ##
      # Returns the shortcuts of skipper.
      #
      # ---
      #
      # Return:
      # String The shortcuts of skipper.
      def get_shortcuts
        @shortcuts.clone
      end
    end
  end
end
