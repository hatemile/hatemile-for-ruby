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

require File.join(File.dirname(File.dirname(__FILE__)), 'html_dom_text_node')
require File.join(File.dirname(__FILE__), 'nokogiri_html_dom_node')

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
        # The NokogiriHTMLDOMTextNode class is official implementation of
        # HTMLDOMTextNode interface for the Nokogiri library.
        class NokogiriHTMLDOMTextNode < Hatemile::Util::Html::HTMLDOMTextNode
          include NokogiriHTMLDOMNode

          public_class_method :new

          ##
          # Initializes a new object that encapsulate the Nokogiri text node.
          #
          # @param text_node [Nokogiri::XML::Text] The Nokogiri text node.
          def initialize(text_node)
            @data = text_node
            init(text_node, self)
          end

          ##
          # @see Hatemile::Util::Html::HTMLDOMTextNode#set_text_content
          def set_text_content(text)
            @data.content = text
          end

          ##
          # @see Hatemile::Util::Html::HTMLDOMNode#append_text
          def append_text(text)
            set_text_content(get_text_content + text)
            self
          end

          ##
          # @see Hatemile::Util::Html::HTMLDOMNode#set_data
          def set_data(data)
            @data = data
            set_node(data)
          end
        end
      end
    end
  end
end
