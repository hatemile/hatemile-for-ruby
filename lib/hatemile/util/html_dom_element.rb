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
      end
      
      ##
      # Remove a attribute of element.
      # 
      # ---
      # 
      # Parameters:
      #  1. String +name+ The name of attribute.
      def removeAttribute(name)
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
      end
      
      ##
      # Returns the text of element.
      # 
      # ---
      # 
      # Return:
      # String The text of element.
      def getTextContent()
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
      end
      
      ##
      # Remove this element of the parser.
      # 
      # ---
      # 
      # Return:
      # Hatemile::Util::HTMLDOMElement The removed element.
      def removeElement()
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
      end
      
      ##
      # Returns the children of this element.
      # 
      # ---
      # 
      # Return:
      # Array(Hatemile::Util::HTMLDOMElement) The children of this element.
      def getChildren()
      end
      
      ##
      # Append a text child.
      # 
      # ---
      # 
      # Parameters:
      #  1. String The text.
      def appendText(text)
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
      end
      
      ##
      # Returns the parent element of this element.
      # 
      # ---
      # 
      # Return:
      # Hatemile::Util::HTMLDOMElement The parent element of this element.
      def getParentElement()
      end
      
      ##
      # Returns the inner HTML code of this element.
      # 
      # ---
      # 
      # Return:
      # String The inner HTML code of this element.
      def getInnerHTML()
      end
      
      ##
      # Modify the inner HTML code of this element.
      # 
      # ---
      # 
      # Parameters:
      #  1. String The HTML code.
      def setInnerHTML(html)
      end
      
      ##
      # Returns the HTML code of this element.
      # 
      # ---
      # 
      # Return:
      # String The HTML code of this element.
      def getOuterHTML()
      end
      
      ##
      # Returns the native object of this element.
      # 
      # ---
      # 
      # Return:
      # Object The native object of this element.
      def getData()
      end
      
      ##
      # Modify the native object of this element.
      # 
      # ---
      # 
      # Parameters:
      #  1. Object The native object of this element.
      def setData(data)
      end
      
      ##
      # Returns the first element child of this element.
      # 
      # ---
      # 
      # Return:
      # Hatemile::Util::HTMLDOMElement The first element child of this element.
      def getFirstElementChild()
      end
      
      ##
      # Returns the last element child of this element.
      # 
      # ---
      # 
      # Return:
      # Hatemile::Util::HTMLDOMElement The last element child of this element.
      def getLastElementChild()
      end
      
      ##
      # Clone this element.
      # 
      # ---
      # 
      # Return:
      # Hatemile::Util::HTMLDOMElement The clone.
      def cloneElement()
      end
    end
  end
end
