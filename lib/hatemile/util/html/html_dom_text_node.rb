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

require File.join(File.dirname(__FILE__), 'html_dom_node')

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
      # The HTMLDOMTextNode interface contains the methods for access of the
      # HTML TextNode.
      #
      # @abstract
      class HTMLDOMTextNode < HTMLDOMNode
        private_class_method :new

        ##
        # Change the text content of text node.
        #
        # @abstract
        # @param text [String] The new text content.
        def set_text_content(text)
          # Interface method
        end
      end
    end
  end
end
