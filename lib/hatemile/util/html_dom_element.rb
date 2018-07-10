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
    # The HTMLDOMElement interface contains the methods for access of the HTML
    # element.
    class HTMLDOMElement
      private_class_method :new

      ##
      # Returns the tag name of element.
      #
      # @return [String] The tag name of element in uppercase letters.
      def get_tag_name
        # Interface method
      end

      ##
      # Returns the value of a attribute.
      #
      # @param name [String] The name of attribute.
      # @return [String] The value of the attribute, if the element not contains
      #   the attribute returns nil.
      def get_attribute(name)
        # Interface method
      end

      ##
      # Create or modify a attribute.
      #
      # @param name [String] The name of attribute.
      # @param value [String] The value of attribute.
      # @return [void]
      def set_attribute(name, value)
        # Interface method
      end

      ##
      # Remove a attribute of element.
      #
      # @param name [String] The name of attribute.
      # @return [void]
      def remove_attribute(name)
        # Interface method
      end

      ##
      # Returns if the element has an attribute.
      #
      # @param name [String] The name of attribute.
      # @return [Boolean] True if the element has the attribute or false if the
      #   element not has the attribute.
      def has_attribute?(name)
        # Interface method
      end

      ##
      # Returns if the element has attributes.
      #
      # @return [Boolean] True if the element has attributes or false if the
      #   element not has attributes.
      def has_attributes?
        # Interface method
      end

      ##
      # Returns the text of element.
      #
      # @return [String] The text of element.
      def get_text_content
        # Interface method
      end

      ##
      # Insert a element before this element.
      #
      # @param new_element [Hatemile::Util::HTMLDOMElement] The element that be
      #   inserted.
      # @return [Hatemile::Util::HTMLDOMElement] The element inserted.
      def insert_before(new_element)
        # Interface method
      end

      ##
      # Insert a element after this element.
      #
      # @param new_element [Hatemile::Util::HTMLDOMElement] The element that be
      #   inserted.
      # @return [Hatemile::Util::HTMLDOMElement] The element inserted.
      def insert_after(new_element)
        # Interface method
      end

      ##
      # Remove this element of the parser.
      #
      # @return [Hatemile::Util::HTMLDOMElement] The removed element.
      def remove_element
        # Interface method
      end

      ##
      # Replace this element for other element.
      #
      # @param new_element [Hatemile::Util::HTMLDOMElement] The element that
      #   replace this element.
      # @return [Hatemile::Util::HTMLDOMElement] The element replaced.
      def replace_element(new_element)
        # Interface method
      end

      ##
      # Append a element child.
      #
      # @param element [Hatemile::Util::HTMLDOMElement] The element that be
      #   inserted.
      # @return [Hatemile::Util::HTMLDOMElement] The element inserted.
      def append_element(element)
        # Interface method
      end

      ##
      # Returns the children of this element.
      #
      # @return [Array<Hatemile::Util::HTMLDOMElement>] The children of this
      #   element.
      def get_children
        # Interface method
      end

      ##
      # Append a text child.
      #
      # @param text [String] The text.
      # @return [void]
      def append_text(text)
        # Interface method
      end

      ##
      # Returns if the element has children.
      #
      # @return [Boolean] True if the element has children or false if the
      #   element not has children.
      def has_children?
        # Interface method
      end

      ##
      # Returns the parent element of this element.
      #
      # @return [Hatemile::Util::HTMLDOMElement] The parent element of this
      #   element.
      def get_parent_element
        # Interface method
      end

      ##
      # Returns the inner HTML code of this element.
      #
      # @return [String] The inner HTML code of this element.
      def get_inner_html
        # Interface method
      end

      ##
      # Modify the inner HTML code of this element.
      #
      # @param html [String] The HTML code.
      # @return [void]
      def set_inner_html(html)
        # Interface method
      end

      ##
      # Returns the HTML code of this element.
      #
      # @return [String] The HTML code of this element.
      def get_outer_html
        # Interface method
      end

      ##
      # Returns the native object of this element.
      #
      # @return [Object] The native object of this element.
      def get_data
        # Interface method
      end

      ##
      # Modify the native object of this element.
      #
      # @param data [Object] The native object of this element.
      # @return [void]
      def set_data(data)
        # Interface method
      end

      ##
      # Returns the first element child of this element.
      #
      # @return [Hatemile::Util::HTMLDOMElement] The first element child of this
      #   element.
      def get_first_element_child
        # Interface method
      end

      ##
      # Returns the last element child of this element.
      #
      # @return [Hatemile::Util::HTMLDOMElement] The last element child of this
      #   element.
      def get_last_element_child
        # Interface method
      end

      ##
      # Clone this element.
      #
      # @return [Hatemile::Util::HTMLDOMElement] The clone.
      def clone_element
        # Interface method
      end
    end
  end
end
