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

##
# The Hatemile module contains the interfaces with the acessibility solutions.
module Hatemile
  ##
  # The Hatemile::Util module contains the utilities of library.
  module Util
    ##
    # The Hatemile::Util::NokogiriLib module contains the implementation of HTML
    # handles for Nokogiri library.
    module NokogiriLib
      ##
      # The NokogiriHTMLDOMElement class is official implementation of
      # HTMLDOMElement interface for the Nokogiri library.
      class NokogiriHTMLDOMElement < Hatemile::Util::HTMLDOMElement
        public_class_method :new

        ##
        # Tags that are self closing.
        SELF_CLOSING_TAGS = %w[
          area base br col embed hr img input keygen
          link menuitem meta param source track wbr
        ].freeze

        ##
        # Initializes a new object that encapsulate the Nokogiri Node.
        #
        # @param element [Nokogiri::XML::Node] The Nokogiri Node.
        def initialize(element)
          @data = element
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#get_tag_name
        def get_tag_name
          @data.name.upcase
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#get_attribute
        def get_attribute(name)
          @data.get_attribute(name)
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#set_attribute
        def set_attribute(name, value)
          @data.set_attribute(name, value)
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#remove_attribute
        def remove_attribute(name)
          @data.remove_attribute(name) if has_attribute?(name)
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#has_attribute?
        def has_attribute?(name)
          !@data.attributes[name].nil?
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#has_attributes?
        def has_attributes?
          !@data.attributes.empty?
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#get_text_content
        def get_text_content
          @data.text
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#insert_before
        def insert_before(new_element)
          @data.before(new_element.get_data)
          new_element
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#insert_after
        def insert_after(new_element)
          @data.after(new_element.get_data)
          new_element
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#remove_element
        def remove_element
          @data.remove
          self
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#replace_element
        def replace_element(new_element)
          @data.replace(new_element.get_data)
          new_element
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#append_element
        def append_element(element)
          @data.add_child(element.get_data)
          element
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#get_children
        def get_children
          array = []
          @data.children do |child|
            array.push(NokogiriHTMLDOMElement.new(child)) if child.element?
          end
          array
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#append_text
        def append_text(text)
          @data.add_child(Nokogiri::XML::Text.new(text, @data.document))
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#has_children?
        def has_children?
          @data.children.empty? == false
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#get_parent_element
        def get_parent_element
          parent = @data.parent
          if !parent.nil? && parent.element?
            return NokogiriHTMLDOMElement.new(parent)
          end
          nil
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#get_inner_html
        def get_inner_html
          html = ''
          get_children do |child|
            html += child.get_outer_html
          end
          html
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#set_inner_html
        def set_inner_html(html)
          @data.inner_html = html
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#get_outer_html
        def get_outer_html
          to_string(@data)
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#get_data
        def get_data
          @data
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#set_data
        def set_data(data)
          @data = data
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#clone_element
        def clone_element
          NokogiriHTMLDOMElement.new(@data.clone)
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#get_first_element_child
        def get_first_element_child
          return nil unless has_children?
          NokogiriHTMLDOMElement.new(@data.children[0])
        end

        ##
        # @see Hatemile::Util::HTMLDOMElement#get_last_element_child
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

          if node.element? &&
             !(node.children.empty? && self_closing_tag?(node.name))
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
          SELF_CLOSING_TAGS.include?(tag.downcase)
        end
      end
    end
  end
end
