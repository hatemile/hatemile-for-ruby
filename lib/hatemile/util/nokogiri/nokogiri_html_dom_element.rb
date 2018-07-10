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
      # The NokogiriHTMLDOMElement class is official implementation of
      # HTMLDOMElement interface for the Nokogiri library.
      class NokogiriHTMLDOMElement < Hatemile::Util::HTMLDOMElement
        public_class_method :new

        @@self_closing_tags = ['area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input', 'keygen', 'link', 'menuitem', 'meta', 'param', 'source', 'track', 'wbr']

        ##
        # Initializes a new object that encapsulate the Nokogiri Node.
        #
        # @param element [Nokogiri::XML::Node] The Nokogiri Node.
        def initialize(element)
          @data = element
        end

        def get_tag_name
          @data.name.upcase
        end

        def get_attribute(name)
          @data.get_attribute(name)
        end

        def set_attribute(name, value)
          @data.set_attribute(name, value)
        end

        def remove_attribute(name)
          @data.remove_attribute(name) if has_attribute?(name)
        end

        def has_attribute?(name)
          !@data.attributes[name].nil?
        end

        def has_attributes?
          !@data.attributes.empty?
        end

        def get_text_content
          @data.text
        end

        def insert_before(new_element)
          @data.before(new_element.get_data)
          new_element
        end

        def insert_after(new_element)
          @data.after(new_element.get_data)
          new_element
        end

        def remove_element
          @data.remove
          self
        end

        def replace_element(new_element)
          @data.replace(new_element.get_data)
          new_element
        end

        def append_element(element)
          @data.add_child(element.get_data)
          element
        end

        def get_children
          array = []
          @data.children do |child|
            array.push(NokogiriHTMLDOMElement.new(child)) if child.element?
          end
          array
        end

        def append_text(text)
          @data.add_child(Nokogiri::XML::Text.new(text, @data.document))
        end

        def has_children?
          @data.children.empty? == false
        end

        def get_parent_element
          parent = @data.parent
          if !parent.nil? && parent.element?
            return NokogiriHTMLDOMElement.new(parent)
          end
          nil
        end

        def get_inner_html
          html = ''
          get_children do |child|
            html += child.get_outer_html
          end
          html
        end

        def set_inner_html(html)
          @data.inner_html = html
        end

        def get_outer_html
          to_string(@data)
        end

        def get_data
          @data
        end

        def set_data(data)
          @data = data
        end

        def clone_element
          NokogiriHTMLDOMElement.new(@data.clone)
        end

        def get_first_element_child
          return nil unless has_children?
          NokogiriHTMLDOMElement.new(@data.children[0])
        end

        def get_last_element_child
          return nil unless has_children?
          children = @data.children
          NokogiriHTMLDOMElement.new(children[children.length - 1])
        end

        ##
        # Convert a Nokogiri Node to a HTML code.
        #
        # @param node [Nokogiri::XML::Node] The Nokogiri Node.
        # @return [String] The HTML code of the Nokogiri Node.
        def to_string(node)
          string = ''
          if node.element?
            string += "<#{node.name.downcase}"
            node.attributes.each do |attribute, value|
              string += " #{attribute}=\"#{value}\""
            end
            string += if node.children.empty? && self_closing_tag?(node.name)
                        ' />'
                      else
                        '>'
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
            string += to_string(child)
          end

          if node.element? && !(node.children.empty? && self_closing_tag?(node.name))
            string += "</#{node.name.downcase}>"
          end
          string
        end

        ##
        # Returns if the tag is self closing.
        #
        # @param tag [String] The element tag.
        # @return [Boolean] True if the tag is self closing or false if not.
        def self_closing_tag?(tag)
          @@self_closing_tags.include?(tag.downcase)
        end
      end
    end
  end
end
