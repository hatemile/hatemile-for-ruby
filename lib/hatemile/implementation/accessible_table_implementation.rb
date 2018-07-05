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
      def generatePart(part)
        rows = @parser.find(part).findChildren('tr').listResults
        table = []
        rows.each do |row|
          table.push(self.generateColspan(@parser.find(row).findChildren('td,th').listResults))
        end
        return self.generateRowspan(table)
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
      def generateRowspan(rows)
        copy = [].concat(rows)
        table = []
        unless rows.empty?
          lengthRows = rows.size
          (0..lengthRows - 1).each do |i|
            columnIndex = 0
            cells = [].concat(copy[i])
            if table.size <= i
              table[i] = []
            end
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
              if cell.hasAttribute?('rowspan')
                rowspan = cell.getAttribute('rowspan').to_i
                if (rowspan > 1)
                  (1..rowspan - 1).each do |k|
                    n = i + k
                    if table[n].nil?
                      table[n] = []
                    end
                    table[n][m] = cell
                  end
                end
              end
            end
          end
        end
        return table
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
      def generateColspan(row)
        copy = [].concat(row)
        cells = [].concat(row)
        size = row.size
        (0..size - 1).each do |i|
          cell = cells[i]
          if cell.hasAttribute?('colspan')
            colspan = cell.getAttribute('colspan').to_i
            if colspan > 1
              (1..colspan - 1).each do |j|
                copy.insert(i + j, cell)
              end
            end
          end
        end
        return copy
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
      def validateHeader(header)
        if header.empty?
          return false
        end
        length = -1
        header.each do |row|
          if row.empty?
            return false
          elsif length == -1
            length = row.size
          elsif row.size != length
            return false
          end
        end
        return true
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
      def returnListIdsColumns(header, index)
        ids = []
        header.each do |row|
          if row[index].getTagName == 'TH'
            ids.push(row[index].getAttribute('id'))
          end
        end
        return ids
      end

      ##
      # Fix the table body or table footer.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +element+ The table body or table footer.
      def fixBodyOrFooter(element)
        table = self.generatePart(element)
        headersIds = []
        table.each do |cells|
          headersIds.clear
          cells.each do |cell|
            if cell.getTagName == 'TH'
              Hatemile::Util::CommonFunctions.generateId(cell, @prefixId)
              headersIds.push(cell.getAttribute('id'))

              cell.setAttribute('scope', 'row')
            end
          end
          unless headersIds.empty?
            cells.each do |cell|
              if cell.getTagName == 'TD'
                headers = cell.getAttribute('headers')
                headersIds.each do |headerId|
                  headers = Hatemile::Util::CommonFunctions.increaseInList(headers, headerId)
                end
                cell.setAttribute('headers', headers)
              end
            end
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
      def fixHeader(tableHeader)
        cells = @parser.find(tableHeader).findChildren('tr').findChildren('th').listResults
        cells.each do |cell|
          Hatemile::Util::CommonFunctions.generateId(cell, @prefixId)

          cell.setAttribute('scope', 'col')
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
        @prefixId = configure.getParameter('prefix-generated-ids')
        @dataIgnore = 'data-ignoreaccessibilityfix'
      end

      def fixAssociationCellsTable(table)
        header = @parser.find(table).findChildren('thead').firstResult
        body = @parser.find(table).findChildren('tbody').firstResult
        footer = @parser.find(table).findChildren('tfoot').firstResult
        unless header.nil?
          self.fixHeader(header)

          headerCells = self.generatePart(header)
          if (!body.nil?) and (self.validateHeader(headerCells))
            lengthHeader = headerCells[0].size
            fakeTable = self.generatePart(body)
            unless footer.nil?
              fakeTable = fakeTable.concat(self.generatePart(footer))
            end
            fakeTable.each do |cells|
              if (cells.size == lengthHeader)
                i = 0
                cells.each do |cell|
                  headersIds = self.returnListIdsColumns(headerCells, i)
                  headers = cell.getAttribute('headers')
                  headersIds.each do |headersId|
                    headers = Hatemile::Util::CommonFunctions.increaseInList(headers, headersId)
                  end
                  cell.setAttribute('headers', headers)
                  i += 1
                end
              end
            end
          end
        end
        unless body.nil?
          self.fixBodyOrFooter(body)
        end
        unless footer.nil?
          self.fixBodyOrFooter(footer)
        end
      end

      def fixAssociationCellsTables
        tables = @parser.find('table').listResults
        tables.each do |table|
          unless table.hasAttribute?(@dataIgnore)
            self.fixAssociationCellsTable(table)
          end
        end
      end
    end
  end
end
