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
  # The AccessibleAssociation interface improve accessibility, associating
  # elements.
  #
  # @abstract
  class AccessibleAssociation
    private_class_method :new

    ##
    # Associate all data cells with header cells of table.
    #
    # @abstract
    # @param table [Hatemile::Util::Html::HTMLDOMElement] The table.
    # @return [void]
    def fix_association_cells_table(table)
      # Interface method
    end

    ##
    # Associate all data cells with header cells of all tables of page.
    #
    # @abstract
    # @return [void]
    def fix_association_cells_tables
      # Interface method
    end

    ##
    # Associate label with field.
    #
    # @abstract
    # @param label [Hatemile::Util::Html::HTMLDOMElement] The label.
    # @return [void]
    def fix_label(label)
      # Interface method
    end

    ##
    # Associate all labels of page with fields.
    #
    # @abstract
    # @return [void]
    def fix_labels
      # Interface method
    end
  end
end
