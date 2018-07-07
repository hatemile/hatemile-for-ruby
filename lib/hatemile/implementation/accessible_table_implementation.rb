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

require File.dirname(__FILE__) + '/../accessible_table.rb'
require File.dirname(__FILE__) + '/../util/common_functions.rb'

module Hatemile
  module Implementation
    ##
    # The AccessibleTableImplementation class is official implementation of
    # AccessibleTable interface.
    class AccessibleTableImplementation < AccessibleTable
      public_class_method :new

      protected

      ##
      # Returns a list that represents the table.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +part+ The table header, table footer or table body.
      # Return:
      # Array(Array(Hatemile::Util::HTMLDOMElement)) The list that represents the table.
      def generate_part(part)
        rows = @parser.find(part).find_children('tr').list_results
        table = []
        rows.each do |row|
          table.push(generate_colspan(@parser.find(row).find_children('td,th').list_results))
        end
        generate_rowspan(table)
      end

      ##
      # Returns a list that represents the table with the rowspans.
      #
      # ---
      #
      # Parameters:
      #  1. Array(Array(Hatemile::Util::HTMLDOMElement)) +rows+ The list that represents the table without the rowspans.
      # Return:
      # Array(Array(Hatemile::Util::HTMLDOMElement)) The list that represents the table with the rowspans.
      def generate_rowspan(rows)
        copy = [].concat(rows)
        table = []
        unless rows.empty?
          lengthRows = rows.size
          (0..lengthRows - 1).each do |i|
            columnIndex = 0
            cells = [].concat(copy[i])
            table[i] = [] if table.size <= i
            lengthCells = cells.size
            (0..lengthCells - 1).each do |j|
              cell = cells[j]
              m = j + columnIndex
              row = table[i]
              until row[m].nil?
                columnIndex += 1
                m = j + columnIndex
              end
              row[m] = cell

              next unless cell.has_attribute?('rowspan')

              rowspan = cell.get_attribute('rowspan').to_i

              next unless rowspan > 1

              (1..rowspan - 1).each do |k|
                n = i + k
                table[n] = [] if table[n].nil?
                table[n][m] = cell
              end
            end
          end
        end
        table
      end

      ##
      # Returns a list that represents the line of table with the colspans.
      #
      # ---
      #
      # Parameters:
      #  1. Array(Hatemile::Util::HTMLDOMElement) +row+ The list that represents the line of table without the
      #  colspans.
      # Return:
      # Array(Hatemile::Util::HTMLDOMElement) The list that represents the line of table with the colspans.
      def generate_colspan(row)
        copy = [].concat(row)
        cells = [].concat(row)
        size = row.size
        (0..size - 1).each do |i|
          cell = cells[i]

          next unless cell.has_attribute?('colspan')

          colspan = cell.get_attribute('colspan').to_i

          next unless colspan > 1

          (1..colspan - 1).each do |j|
            copy.insert(i + j, cell)
          end
        end
        copy
      end

      ##
      # Validate the list that represents the table header.
      #
      # ---
      #
      # Parameters:
      #  1. Array(Array(Hatemile::Util::HTMLDOMElement)) +header+ The list that represents the table header.
      # Return:
      # Boolean True if the table header is valid or false if the table header is
      # not valid.
      def validate_header(header)
        return false if header.empty?
        length = -1
        header.each do |row|
          return false if row.empty?
          length = row.size if length == -1
          return false if row.size != length
        end
        true
      end

      ##
      # Returns a list with ids of rows of same column.
      #
      # ---
      #
      # Parameters:
      #  1. Array(Array(Hatemile::Util::HTMLDOMElement)) +header+ The list that represents the table header.
      #  2. Integer +index+ The index of columns.
      # Return:
      # Array(String) The list with ids of rows of same column.
      def return_list_ids_columns(header, index)
        ids = []
        header.each do |row|
          if row[index].get_tag_name == 'TH'
            ids.push(row[index].get_attribute('id'))
          end
        end
        ids
      end

      ##
      # Fix the table body or table footer.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +element+ The table body or table footer.
      def fix_body_or_footer(element)
        table = generate_part(element)
        headersIds = []
        table.each do |cells|
          headersIds.clear
          cells.each do |cell|
            next unless cell.get_tag_name == 'TH'

            Hatemile::Util::CommonFunctions.generate_id(cell, @prefixId)
            headersIds.push(cell.get_attribute('id'))
            cell.set_attribute('scope', 'row')
          end

          cells.each do |cell|
            next unless cell.get_tag_name == 'TD'

            headers = cell.get_attribute('headers')
            headersIds.each do |headerId|
              headers = Hatemile::Util::CommonFunctions.increase_in_list(headers, headerId)
            end
            cell.set_attribute('headers', headers)
          end
        end
      end

      ##
      # Fix the table header.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +tableHeader+ The table header.
      def fix_header(tableHeader)
        cells = @parser.find(tableHeader).find_children('tr').find_children('th').list_results
        cells.each do |cell|
          Hatemile::Util::CommonFunctions.generate_id(cell, @prefixId)

          cell.set_attribute('scope', 'col')
        end
      end

      public

      ##
      # Initializes a new object that manipulate the accessibility of the tables
      # of parser.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMParser +parser+ The HTML parser.
      #  2. Hatemile::Util::Configure +configure+ The configuration of HaTeMiLe.
      def initialize(parser, configure)
        @parser = parser
        @prefixId = configure.get_parameter('prefix-generated-ids')
        @dataIgnore = 'data-ignoreaccessibilityfix'
      end

      def fix_association_cells_table(table)
        header = @parser.find(table).find_children('thead').first_result
        body = @parser.find(table).find_children('tbody').first_result
        footer = @parser.find(table).find_children('tfoot').first_result
        unless header.nil?
          fix_header(header)

          headerCells = generate_part(header)
          if !body.nil? && validate_header(headerCells)
            lengthHeader = headerCells[0].size
            fakeTable = generate_part(body)
            unless footer.nil?
              fakeTable = fakeTable.concat(generate_part(footer))
            end
            fakeTable.each do |cells|
              next unless cells.size == lengthHeader

              i = 0
              cells.each do |cell|
                headersIds = return_list_ids_columns(headerCells, i)
                headers = cell.get_attribute('headers')
                headersIds.each do |headersId|
                  headers = Hatemile::Util::CommonFunctions.increase_in_list(headers, headersId)
                end
                cell.set_attribute('headers', headers)
                i += 1
              end
            end
          end
        end
        fix_body_or_footer(body) unless body.nil?
        fix_body_or_footer(footer) unless footer.nil?
      end

      def fix_association_cells_tables
        tables = @parser.find('table').list_results
        tables.each do |table|
          unless table.has_attribute?(@dataIgnore)
            fix_association_cells_table(table)
          end
        end
      end
    end
  end
end
