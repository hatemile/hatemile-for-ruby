#Copyright 2014 Carlson Santana Cruz
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

require File.dirname(__FILE__) + '/../AccessibleTable.rb'
require File.dirname(__FILE__) + '/../util/CommonFunctions.rb'

module Hatemile
	module Implementation
		class AccessibleTableImpl < AccessibleTable
			public_class_method :new
			
			def initialize(parser, configure)
				@parser = parser
				@prefixId = configure.getParameter('prefix-generated-ids')
				@dataIgnore = configure.getParameter('data-ignore')
			end
			
			protected
			def generatePart(part)
				rows = @parser.find(part).findChildren('tr').listResults()
				table = Array.new()
				rows.each() do |row|
					table.push(self.generateColspan(@parser.find(row).findChildren('td,th').listResults()))
				end
				return self.generateRowspan(table)
			end
			
			def generateRowspan(rows)
				copy = Array.new()
				copy.concat(rows)
				table = Array.new()
				if not rows.empty?
					lengthRows = rows.size() - 1
					(0..lengthRows).each() do |i|
						columnIndex = 0
						cells = [].concat(copy[i])
						if table[i] == nil
							table[i] = Array.new()
						end
						lengthCells = cells.size() - 1
						(0..lengthCells).each() do |j|
							cell = cells[j]
							m = j + columnIndex
							row = table[i]
							while row[m] != nil
								columnIndex += 1
								m = j + columnIndex
							end
							row[m] = cell
							if cell.hasAttribute?('rowspan')
								rowspan = cell.getAttribute('rowspan').to_i()
								if (rowspan > 1)
									(1..rowspan - 1).each() do |k|
										n = i + k
										if table[n] == nil
											table[n] = Array.new()
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
			
			def generateColspan(row)
				copy = [].concat(row)
				cells = [].concat(row)
				size = row.size() - 1
				(0..size).each() do |i|
					cell = cells[i]
					if cell.hasAttribute?('colspan')
						colspan = cell.getAttribute('colspan').to_i()
						if colspan > 1
							(1..colspan - 1).each() do |j|
								copy.insert(i + j, cell)
							end
						end
					end
				end
				return copy
			end
			
			def validateHeader(header)
				if (header == nil) or (header.empty?)
					return false
				end
				length = -1
				header.each() do |elements|
					if (elements == nil) or (elements.empty?)
						return false
					elsif length == -1
						length = elements.size()
					elsif elements.size() != length
						return false
					end
				end
				return true
			end
			
			def returnListIdsColumns(header, index)
				ids = Array.new()
				header.each() do |row|
					if row[index].getTagName() == 'TH'
						ids.push(row[index].getAttribute('id'))
					end
				end
				return ids
			end
			
			def fixBodyOrFooter(element)
				table = self.generatePart(element)
				table.each() do |cells|
					headersIds = Array.new()
					cells.each() do |cell|
						if cell.getTagName() == 'TH'
							Hatemile::Util::CommonFunctions.generateId(cell, @prefixId)
							cell.setAttribute('scope', 'row')
							headersIds.push(cell.getAttribute('id'))
						end
					end
					if not headersIds.empty?
						cells.each() do |cell|
							if cell.getTagName() == 'TD'
								headers = nil
								if cell.hasAttribute?('headers')
									headers = cell.getAttribute('headers')
								end
								headersIds.each() do |headerId|
									headers = Hatemile::Util::CommonFunctions.increaseInList(headers, headerId)
								end
								cell.setAttribute('headers', headers)
							end
						end
					end
				end
			end
			
			public
			def fixHeader(element)
				if element.getTagName() == 'THEAD'
					cells = @parser.find(element).findChildren('tr').findChildren('th').listResults()
					cells.each() do |cell|
						Hatemile::Util::CommonFunctions.generateId(cell, @prefixId)
						cell.setAttribute('scope', 'col')
					end
				end
			end
			
			def fixFooter(element)
				if element.getTagName() == 'TFOOT'
					self.fixBodyOrFooter(element)
				end
			end
			
			def fixBody(element)
				if element.getTagName() == 'TBODY'
					self.fixBodyOrFooter(element)
				end
			end
			
			def fixTable(element)
				header = @parser.find(element).findChildren('thead').firstResult()
				body = @parser.find(element).findChildren('tbody').firstResult()
				footer = @parser.find(element).findChildren('tfoot').firstResult()
				if header != nil
					self.fixHeader(header)
					headerCells = self.generatePart(header)
					if (self.validateHeader(headerCells)) and (body != nil)
						lengthHeader = headerCells[0].size()
						table = self.generatePart(body)
						if footer != nil
							table = table.concat(self.generatePart(footer))
						end
						table.each() do |cells|
							i = 0
							if (cells.size() == lengthHeader)
								cells.each() do |cell|
									ids = self.returnListIdsColumns(headerCells, i)
									headers = nil
									if cell.hasAttribute?('headers')
										headers = cell.getAttribute('headers')
									end
									ids.each() do |id|
										headers = Hatemile::Util::CommonFunctions.increaseInList(headers, id)
									end
									cell.setAttribute('headers', headers)
									i += 1
								end
							end
						end
					end
				end
				if body != nil
					self.fixBody(body)
				end
				if footer != nil
					self.fixFooter(footer)
				end
			end
			
			def fixTables()
				elements = @parser.find('table').listResults()
				elements.each() do |element|
					if not element.hasAttribute?(@dataIgnore)
						self.fixTable(element)
					end
				end
			end
		end
	end
end