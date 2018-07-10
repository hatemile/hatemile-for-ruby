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

module Hatemile
  ##
  # The AccessibleTable interface fixes accessibility problems associated
  # with tables.
  #
  # @abstract
  class AccessibleTable
    private_class_method :new

    ##
    # Associate data cells with header cells of table.
    #
    # @abstract
    # @param table [Hatemile::Util::HTMLDOMElement] The table.
    # @return [void]
    def fix_association_cells_table(table)
      # Interface method
    end

    ##
    # Associate data cells with header cells of tables.
    #
    # @abstract
    # @return [void]
    def fix_association_cells_tables
      # Interface method
    end
  end
end
