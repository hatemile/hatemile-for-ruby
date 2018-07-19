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
      # The HTMLDOMNode interface contains the methods for access the Node.
      #
      # @abstract
      class HTMLDOMNode
        private_class_method :new

        ##
        # Returns the text content of node.
        #
        # @abstract
        # @return [String] The text content of node.
        def get_text_content
          # Interface method
        end

        ##
        # Insert a node before this node.
        #
        # @abstract
        # @param new_node [Hatemile::Util::Html::HTMLDOMNode] The node that be
        #   inserted.
        # @return [Hatemile::Util::Html::HTMLDOMNode] This node.
        def insert_before(new_node)
          # Interface method
        end

        ##
        # Insert a node after this node.
        #
        # @abstract
        # @param new_node [Hatemile::Util::Html::HTMLDOMNode] The node that be
        #   inserted.
        # @return [Hatemile::Util::Html::HTMLDOMNode] This node.
        def insert_after(new_node)
          # Interface method
        end

        ##
        # Remove this node of the parser.
        #
        # @abstract
        # @return [Hatemile::Util::Html::HTMLDOMNode] This node.
        def remove_node
          # Interface method
        end

        ##
        # Replace this node for other node.
        #
        # @abstract
        # @param new_node [Hatemile::Util::Html::HTMLDOMNode] The node that
        #   replace this node.
        # @return [Hatemile::Util::Html::HTMLDOMNode] This node.
        def replace_node(new_node)
          # Interface method
        end

        ##
        # Append a text content in node.
        #
        # @abstract
        # @param text [String] The text.
        # @return [Hatemile::Util::Html::HTMLDOMNode] This node.
        def append_text(text)
          # Interface method
        end

        ##
        # Returns the parent element of this node.
        #
        # @abstract
        # @return [Hatemile::Util::Html::HTMLDOMElement] The parent element of
        #   this node.
        def get_parent_element
          # Interface method
        end

        ##
        # Returns the native object of this node.
        #
        # @abstract
        # @return [Object] The native object of this node.
        def get_data
          # Interface method
        end

        ##
        # Modify the native object of this node.
        #
        # @abstract
        # @param data [Object] The native object of this node.
        # @return [void]
        def set_data(data)
          # Interface method
        end
      end
    end
  end
end
