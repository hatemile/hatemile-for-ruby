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
    # The HTMLDOMParser interface contains the methods for access a native parser.
    class HTMLDOMParser
      private_class_method :new

      ##
      # Find all elements in the parser by selector.
      #
      # ---
      #
      # Parameters:
      #  1. String|Hatemile::Util::HTMLDOMElement +selector+ The selector.
      # Return:
      # Hatemile::Util::Parser The parser with the elements found.
      def find(selector)
        # Interface method
      end

      ##
      # Find all elements in the parser by selector, children of found elements.
      #
      # ---
      #
      # Parameters:
      #  1. String|Hatemile::Util::HTMLDOMElement +selector+ The selector.
      # Return:
      # Hatemile::Util::Parser The parser with the elements found.
      def findChildren(selector)
        # Interface method
      end

      ##
      # Find all elements in the parser by selector, descendants of found
      # elements.
      #
      # ---
      #
      # Parameters:
      #  1. String|Hatemile::Util::HTMLDOMElement +selector+ The selector.
      # Return:
      # Hatemile::Util::Parser The parser with the elements found.
      def findDescendants(selector)
        # Interface method
      end

      ##
      # Find all elements in the parser by selector, ancestors of found elements.
      #
      # ---
      #
      # Parameters:
      #  1. String|Hatemile::Util::HTMLDOMElement +selector+ The selector.
      # Return:
      # Hatemile::Util::Parser The parser with the elements found.
      def findAncestors(selector)
        # Interface method
      end

      ##
      # Returns the first element found.
      #
      # ---
      #
      # Return:
      # Hatemile::Util::HTMLDOMElement The first element found or null if not have elements found.
      def firstResult()
        # Interface method
      end

      ##
      # Returns the last element found.
      #
      # ---
      #
      # Return:
      # Hatemile::Util::HTMLDOMElement The last element found or null if not have elements found.
      def lastResult()
        # Interface method
      end

      ##
      # Returns a list with all elements found.
      #
      # ---
      #
      # Return:
      # Array(Hatemile::Util::HTMLDOMElement) The list with all elements found.
      def listResults()
        # Interface method
      end

      ##
      # Create a element.
      #
      # ---
      #
      # Parameters:
      #  1. String +tag+ The tag of element.
      # Return:
      # Hatemile::Util::HTMLDOMElement The element created.
      def createElement(tag)
        # Interface method
      end

      ##
      # Returns the HTML code of parser.
      #
      # ---
      #
      # Return:
      # String The HTML code of parser.
      def getHTML()
        # Interface method
      end

      ##
      # Returns the parser.
      #
      # ---
      #
      # Return:
      # Object The parser or root element of the parser.
      def getParser()
        # Interface method
      end

      ##
      # Clear the memory of this object.
      def clearParser()
        # Interface method
      end
    end
  end
end
