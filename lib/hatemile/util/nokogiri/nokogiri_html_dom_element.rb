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

require File.dirname(__FILE__) + '/../html_dom_element.rb'

module Hatemile
  module Util
    module NokogiriLib
      ##
      # The NokogiriHTMLDOMElement class is official implementation of HTMLDOMElement
      # interface for the Nokogiri library.
      class NokogiriHTMLDOMElement < Hatemile::Util::HTMLDOMElement
        public_class_method :new

        @@self_closing_tags = ['area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input', 'keygen', 'link', 'menuitem', 'meta', 'param', 'source', 'track', 'wbr']

        ##
        # Initializes a new object that encapsulate the Nokogiri Node.
        #
        # ---
        #
        # Parameters:
        #  1. Nokogiri::XML::Node +element+ The Nokogiri Node.
        def initialize(element)
          @data = element
        end

        def getTagName
          @data.name.upcase
        end

        def getAttribute(name)
          @data.get_attribute(name)
        end

        def setAttribute(name, value)
          @data.set_attribute(name, value)
        end

        def removeAttribute(name)
          @data.remove_attribute(name) if hasAttribute?(name)
        end

        def hasAttribute?(name)
          !@data.attributes[name].nil?
        end

        def hasAttributes?
          !@data.attributes.empty?
        end

        def getTextContent
          @data.text
        end

        def insertBefore(newElement)
          @data.before(newElement.getData)
          newElement
        end

        def insertAfter(newElement)
          @data.after(newElement.getData)
          newElement
        end

        def removeElement
          @data.remove
          self
        end

        def replaceElement(newElement)
          @data.replace(newElement.getData)
          newElement
        end

        def appendElement(element)
          @data.add_child(element.getData)
          element
        end

        def getChildren
          array = []
          @data.children do |child|
            array.push(NokogiriHTMLDOMElement.new(child)) if child.element?
          end
          array
        end

        def appendText(text)
          @data.add_child(Nokogiri::XML::Text.new(text, @data.document))
        end

        def hasChildren?
          @data.children.empty? == false
        end

        def getParentElement
          parent = @data.parent
          if !parent.nil? && parent.element?
            return NokogiriHTMLDOMElement.new(parent)
          nil
        end

        def getInnerHTML
          html = ''
          getChildren do |child|
            html += child.getOuterHTML
          end
          html
        end

        def setInnerHTML(html)
          @data.inner_html = html
        end

        def getOuterHTML
          toString(@data)
        end

        def getData
          @data
        end

        def setData(data)
          @data = data
        end

        def cloneElement
          NokogiriHTMLDOMElement.new(@data.clone)
        end

        def getFirstElementChild
          return nil unless hasChildren?
          NokogiriHTMLDOMElement.new(@data.children[0])
        end

        def getLastElementChild
          return nil unless hasChildren?
          children = @data.children
          NokogiriHTMLDOMElement.new(children[children.length - 1])
        end

        ##
        # Convert a Nokogiri Node to a HTML code.
        #
        # ---
        #
        # Parameters:
        #  1. Nokogiri::XML::Node +node+ The Nokogiri Node.
        # Return:
        # String The HTML code of the Nokogiri Node.
        def toString(node)
          string = ''
          if node.element?
            string += "<#{node.name.downcase}"
            node.attributes.each do |attribute, value|
              string += " #{attribute}=\"#{value}\""
            end
            if node.children.empty? && self_closing_tag?(node.name)
              string += ' />'
            else
              string += '>'
            end
          elsif node.comment?
            string += node.to_s
          elsif node.cdata?
            string += node.to_s
          elsif node.html?
            document = node.to_s
            string += document.split("\n")[0] + "\n"
          elsif node.text?
            string += node.text
          end

          node.children.each do |child|
            string += toString(child)
          end

          if node.element? && !(node.children.empty? && self_closing_tag?(node.name))
            string += "</#{node.name.downcase}>"
          end
          string
        end

        ##
        # Returns if the tag is self closing.
        #
        # ---
        #
        # Parameters:
        #  1. String +tag+ The element tag.
        # Return:
        # True if the tag is self closing or false if not.
        def self_closing_tag?(tag)
          @@self_closing_tags.include?(tag.downcase)
        end
      end
    end
  end
end
