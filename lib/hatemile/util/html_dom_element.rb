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
      # ---
      #
      # Return:
      # String The tag name of element in uppercase letters.
      def getTagName()
        # Interface method
      end

      ##
      # Returns the value of a attribute.
      #
      # ---
      #
      # Parameters:
      #  1. String +name+ The name of attribute.
      # Return:
      # String The value of the attribute, if the element not contains the
      # attribute returns nil.
      def getAttribute(name)
        # Interface method
      end

      ##
      # Create or modify a attribute.
      #
      # ---
      #
      # Parameters:
      #  1. String +name+ The name of attribute.
      #  2. String +value+ The value of attribute.
      def setAttribute(name, value)
        # Interface method
      end

      ##
      # Remove a attribute of element.
      #
      # ---
      #
      # Parameters:
      #  1. String +name+ The name of attribute.
      def removeAttribute(name)
        # Interface method
      end

      ##
      # Returns if the element has an attribute.
      #
      # ---
      #
      # Parameters:
      #  1. String +name+ The name of attribute.
      # Return:
      # Boolean True if the element has the attribute or false if the element not
      # has the attribute.
      def hasAttribute?(name)
        # Interface method
      end

      ##
      # Returns if the element has attributes.
      #
      # ---
      #
      # Return:
      # Boolean True if the element has attributes or false if the element not
      # has attributes.
      def hasAttributes?()
        # Interface method
      end

      ##
      # Returns the text of element.
      #
      # ---
      #
      # Return:
      # String The text of element.
      def getTextContent()
        # Interface method
      end

      ##
      # Insert a element before this element.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +newElement+ The element that be inserted.
      # Return:
      # Hatemile::Util::HTMLDOMElement The element inserted.
      def insertBefore(newElement)
        # Interface method
      end

      ##
      # Insert a element after this element.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +newElement+ The element that be inserted.
      # Return:
      # Hatemile::Util::HTMLDOMElement The element inserted.
      def insertAfter(newElement)
        # Interface method
      end

      ##
      # Remove this element of the parser.
      #
      # ---
      #
      # Return:
      # Hatemile::Util::HTMLDOMElement The removed element.
      def removeElement()
        # Interface method
      end

      ##
      # Replace this element for other element.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +newElement+ The element that replace this element.
      # Return:
      # Hatemile::Util::HTMLDOMElement The element replaced.
      def replaceElement(newElement)
        # Interface method
      end

      ##
      # Append a element child.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +element+ The element that be inserted.
      # Return:
      # Hatemile::Util::HTMLDOMElement The element inserted.
      def appendElement(element)
        # Interface method
      end

      ##
      # Returns the children of this element.
      #
      # ---
      #
      # Return:
      # Array(Hatemile::Util::HTMLDOMElement) The children of this element.
      def getChildren()
        # Interface method
      end

      ##
      # Append a text child.
      #
      # ---
      #
      # Parameters:
      #  1. String The text.
      def appendText(text)
        # Interface method
      end

      ##
      # Returns if the element has children.
      #
      # ---
      #
      # Return:
      # Boolean True if the element has children or false if the element not has
      # children.
      def hasChildren?()
        # Interface method
      end

      ##
      # Returns the parent element of this element.
      #
      # ---
      #
      # Return:
      # Hatemile::Util::HTMLDOMElement The parent element of this element.
      def getParentElement()
        # Interface method
      end

      ##
      # Returns the inner HTML code of this element.
      #
      # ---
      #
      # Return:
      # String The inner HTML code of this element.
      def getInnerHTML()
        # Interface method
      end

      ##
      # Modify the inner HTML code of this element.
      #
      # ---
      #
      # Parameters:
      #  1. String The HTML code.
      def setInnerHTML(html)
        # Interface method
      end

      ##
      # Returns the HTML code of this element.
      #
      # ---
      #
      # Return:
      # String The HTML code of this element.
      def getOuterHTML()
        # Interface method
      end

      ##
      # Returns the native object of this element.
      #
      # ---
      #
      # Return:
      # Object The native object of this element.
      def getData()
        # Interface method
      end

      ##
      # Modify the native object of this element.
      #
      # ---
      #
      # Parameters:
      #  1. Object The native object of this element.
      def setData(data)
        # Interface method
      end

      ##
      # Returns the first element child of this element.
      #
      # ---
      #
      # Return:
      # Hatemile::Util::HTMLDOMElement The first element child of this element.
      def getFirstElementChild()
        # Interface method
      end

      ##
      # Returns the last element child of this element.
      #
      # ---
      #
      # Return:
      # Hatemile::Util::HTMLDOMElement The last element child of this element.
      def getLastElementChild()
        # Interface method
      end

      ##
      # Clone this element.
      #
      # ---
      #
      # Return:
      # Hatemile::Util::HTMLDOMElement The clone.
      def cloneElement()
        # Interface method
      end
    end
  end
end
