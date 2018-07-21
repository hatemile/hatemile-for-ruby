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
      # The Hatemile::Util::NokogiriLib module contains the implementation of
      # HTML handles for Nokogiri library.
      module NokogiriLib
        ##
        # The NokogiriHTMLDOMNode module is official implementation of
        # HTMLDOMNode methods.
        module NokogiriHTMLDOMNode
          ##
          # Initializes a new object that encapsulate the Nokogiri node.
          #
          # @param node [Nokogiri::XML::Node] The Nokogiri node.
          # @param hatemile_node [Hatemile::Util::Html::HTMLDOMNode] The
          #   HaTeMiLe node.
          def init(node, hatemile_node)
            @node = node
            @hatemile_node = hatemile_node
          end

          ##
          # @see Hatemile::Util::Html::HTMLDOMNode#get_text_content
          def get_text_content
            @node.text
          end

          ##
          # @see Hatemile::Util::Html::HTMLDOMNode#insert_before
          def insert_before(new_node)
            @node.before(new_node.get_data)
            @hatemile_node
          end

          ##
          # @see Hatemile::Util::Html::HTMLDOMNode#insert_after
          def insert_after(new_node)
            @node.after(new_node.get_data)
            @hatemile_node
          end

          ##
          # @see Hatemile::Util::Html::HTMLDOMNode#remove_node
          def remove_node
            @node.remove
            @hatemile_node
          end

          ##
          # @see Hatemile::Util::Html::HTMLDOMNode#replace_node
          def replace_node(new_node)
            @node.replace(new_node.get_data)
            @hatemile_node
          end

          ##
          # @see Hatemile::Util::Html::HTMLDOMNode#get_parent_element
          def get_parent_element
            parent = @node.parent
            if !parent.nil? && parent.element?
              return NokogiriHTMLDOMElement.new(parent)
            end
            nil
          end

          ##
          # @see Hatemile::Util::Html::HTMLDOMNode#get_data
          def get_data
            @node
          end

          ##
          # @see Hatemile::Util::Html::HTMLDOMNode#set_data
          def set_node(node)
            @node = node
          end
        end
      end
    end
  end
end
