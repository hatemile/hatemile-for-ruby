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
    # The HTMLDOMParser interface contains the methods for access a native
    # parser.
    #
    # @abstract
    class HTMLDOMParser
      private_class_method :new

      ##
      # Find all elements in the parser by selector.
      #
      # @abstract
      # @param selector [String, Hatemile::Util::HTMLDOMElement] The selector.
      # @return [Hatemile::Util::Parser] The parser with the elements found.
      def find(selector)
        # Interface method
      end

      ##
      # Find all elements in the parser by selector, children of found elements.
      #
      # @abstract
      # @param selector [String, Hatemile::Util::HTMLDOMElement] The selector.
      # @return [Hatemile::Util::Parser] The parser with the elements found.
      def find_children(selector)
        # Interface method
      end

      ##
      # Find all elements in the parser by selector, descendants of found
      # elements.
      #
      # @abstract
      # @param selector [String, Hatemile::Util::HTMLDOMElement] The selector.
      # @return [Hatemile::Util::Parser] The parser with the elements found.
      def find_descendants(selector)
        # Interface method
      end

      ##
      # Find all elements in the parser by selector, ancestors of found
      # elements.
      #
      # @abstract
      # @param selector [String, Hatemile::Util::HTMLDOMElement] The selector.
      # @return [Hatemile::Util::Parser] The parser with the elements found.
      def find_ancestors(selector)
        # Interface method
      end

      ##
      # Returns the first element found.
      #
      # @abstract
      # @return [Hatemile::Util::HTMLDOMElement] The first element found or null
      #   if not have elements found.
      def first_result
        # Interface method
      end

      ##
      # Returns the last element found.
      #
      # @abstract
      # @return [Hatemile::Util::HTMLDOMElement] The last element found or null
      #   if not have elements found.
      def last_result
        # Interface method
      end

      ##
      # Returns a list with all elements found.
      #
      # @abstract
      # @return [Array<Hatemile::Util::HTMLDOMElement>] The list with all
      #   elements found.
      def list_results
        # Interface method
      end

      ##
      # Create a element.
      #
      # @abstract
      # @param tag [String] The tag of element.
      # @return [Hatemile::Util::HTMLDOMElement] The element created.
      def create_element(tag)
        # Interface method
      end

      ##
      # Returns the HTML code of parser.
      #
      # @abstract
      # @return [String] The HTML code of parser.
      def get_html
        # Interface method
      end

      ##
      # Returns the parser.
      #
      # @abstract
      # @return [Object] The parser or root element of the parser.
      def get_parser
        # Interface method
      end

      ##
      # Clear the memory of this object.
      #
      # @abstract
      # @return [void]
      def clear_parser
        # Interface method
      end
    end
  end
end
