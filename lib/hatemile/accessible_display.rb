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
  # The AccessibleDisplay interface improve accessibility, showing informations.
  #
  # @abstract
  class AccessibleDisplay
    private_class_method :new

    ##
    # Display the shortcuts of element.
    #
    # @abstract
    # @param element [Hatemile::Util::Html::HTMLDOMElement] The element with
    #   shortcuts.
    # @return [void]
    def display_shortcut(element)
      # Interface method
    end

    ##
    # Display all shortcuts of page.
    #
    # @abstract
    # @return [void]
    def display_all_shortcuts
      # Interface method
    end

    ##
    # Display the WAI-ARIA role of element.
    #
    # @abstract
    # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
    # @return [void]
    def display_role(element)
      # Interface method
    end

    ##
    # Display the WAI-ARIA roles of all elements of page.
    #
    # @abstract
    # @return [void]
    def display_all_roles
      # Interface method
    end

    ##
    # Display the headers of each data cell of table.
    #
    # @abstract
    # @param table_cell [Hatemile::Util::Html::HTMLDOMElement] The table cell.
    # @return [void]
    def display_cell_header(table_cell)
      # Interface method
    end

    ##
    # Display the headers of each data cell of all tables of page.
    #
    # @abstract
    # @return [void]
    def display_all_cell_headers
      # Interface method
    end
  end
end
