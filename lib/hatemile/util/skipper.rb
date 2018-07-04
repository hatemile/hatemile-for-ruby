#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

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
      #  2. String +defaultText+ The default text of skipper.
      #  3. String +shortcuts+ The shortcuts of skipper.
      def initialize(selector, defaultText, shortcuts)
        @selector = selector
        @defaultText = defaultText
        if shortcuts.empty?()
          @shortcuts = Array.new()
        else
          @shortcuts = shortcuts.split(/[ \n\t\r]+/)
        end
      end

      ##
      # Returns the selector.
      #
      # ---
      #
      # Return:
      # String The selector.
      def getSelector()
        return @selector
      end

      ##
      # Returns the default text of skipper.
      #
      # ---
      #
      # Return:
      # String The default text of skipper.
      def getDefaultText()
        return @defaultText
      end

      ##
      # Returns the shortcuts of skipper.
      #
      # ---
      #
      # Return:
      # String The shortcuts of skipper.
      def getShortcuts()
        return @shortcuts.clone()
      end
    end
  end
end
