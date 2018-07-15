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
    # The Hatemile::Util::Html module contains the interfaces of HTML handles.
    module Html
      ##
      # The HTMLDOMElement interface contains the methods for access of the HTML
      # element.
      #
      # @abstract
      class HTMLDOMElement
        private_class_method :new

        ##
        # Returns the tag name of element.
        #
        # @abstract
        # @return [String] The tag name of element in uppercase letters.
        def get_tag_name
          # Interface method
        end

        ##
        # Returns the value of a attribute.
        #
        # @abstract
        # @param name [String] The name of attribute.
        # @return [String] The value of the attribute, if the element not
        #   contains the attribute returns nil.
        def get_attribute(name)
          # Interface method
        end

        ##
        # Create or modify a attribute.
        #
        # @abstract
        # @param name [String] The name of attribute.
        # @param value [String] The value of attribute.
        # @return [void]
        def set_attribute(name, value)
          # Interface method
        end

        ##
        # Remove a attribute of element.
        #
        # @abstract
        # @param name [String] The name of attribute.
        # @return [void]
        def remove_attribute(name)
          # Interface method
        end

        ##
        # Returns if the element has an attribute.
        #
        # @abstract
        # @param name [String] The name of attribute.
        # @return [Boolean] True if the element has the attribute or false if
        #   the element not has the attribute.
        def has_attribute?(name)
          # Interface method
        end

        ##
        # Returns if the element has attributes.
        #
        # @abstract
        # @return [Boolean] True if the element has attributes or false if the
        #   element not has attributes.
        def has_attributes?
          # Interface method
        end

        ##
        # Returns the text of element.
        #
        # @abstract
        # @return [String] The text of element.
        def get_text_content
          # Interface method
        end

        ##
        # Insert a element before this element.
        #
        # @abstract
        # @param new_element [Hatemile::Util::Html::HTMLDOMElement] The element
        #   that be inserted.
        # @return [Hatemile::Util::Html::HTMLDOMElement] The element inserted.
        def insert_before(new_element)
          # Interface method
        end

        ##
        # Insert a element after this element.
        #
        # @abstract
        # @param new_element [Hatemile::Util::Html::HTMLDOMElement] The element
        #   that be inserted.
        # @return [Hatemile::Util::Html::HTMLDOMElement] The element inserted.
        def insert_after(new_element)
          # Interface method
        end

        ##
        # Remove this element of the parser.
        #
        # @abstract
        # @return [Hatemile::Util::Html::HTMLDOMElement] The removed element.
        def remove_element
          # Interface method
        end

        ##
        # Replace this element for other element.
        #
        # @abstract
        # @param new_element [Hatemile::Util::Html::HTMLDOMElement] The element
        #   that replace this element.
        # @return [Hatemile::Util::Html::HTMLDOMElement] The element replaced.
        def replace_element(new_element)
          # Interface method
        end

        ##
        # Append a element child.
        #
        # @abstract
        # @param element [Hatemile::Util::Html::HTMLDOMElement] The element that
        #   be inserted.
        # @return [Hatemile::Util::Html::HTMLDOMElement] The element inserted.
        def append_element(element)
          # Interface method
        end

        ##
        # Returns the children of this element.
        #
        # @abstract
        # @return [Array<Hatemile::Util::Html::HTMLDOMElement>] The children of
        #   this element.
        def get_children
          # Interface method
        end

        ##
        # Append a text child.
        #
        # @abstract
        # @param text [String] The text.
        # @return [void]
        def append_text(text)
          # Interface method
        end

        ##
        # Returns if the element has children.
        #
        # @abstract
        # @return [Boolean] True if the element has children or false if the
        #   element not has children.
        def has_children?
          # Interface method
        end

        ##
        # Returns the parent element of this element.
        #
        # @abstract
        # @return [Hatemile::Util::Html::HTMLDOMElement] The parent element of
        #   this element.
        def get_parent_element
          # Interface method
        end

        ##
        # Returns the inner HTML code of this element.
        #
        # @abstract
        # @return [String] The inner HTML code of this element.
        def get_inner_html
          # Interface method
        end

        ##
        # Returns the HTML code of this element.
        #
        # @abstract
        # @return [String] The HTML code of this element.
        def get_outer_html
          # Interface method
        end

        ##
        # Returns the native object of this element.
        #
        # @abstract
        # @return [Object] The native object of this element.
        def get_data
          # Interface method
        end

        ##
        # Modify the native object of this element.
        #
        # @abstract
        # @param data [Object] The native object of this element.
        # @return [void]
        def set_data(data)
          # Interface method
        end

        ##
        # Returns the first element child of this element.
        #
        # @abstract
        # @return [Hatemile::Util::Html::HTMLDOMElement] The first element child
        #   of this element.
        def get_first_element_child
          # Interface method
        end

        ##
        # Returns the last element child of this element.
        #
        # @abstract
        # @return [Hatemile::Util::Html::HTMLDOMElement] The last element child
        #   of this element.
        def get_last_element_child
          # Interface method
        end

        ##
        # Clone this element.
        #
        # @abstract
        # @return [Hatemile::Util::Html::HTMLDOMElement] The clone.
        def clone_element
          # Interface method
        end
      end
    end
  end
end
