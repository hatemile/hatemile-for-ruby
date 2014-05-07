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
module Hatemile
	module Util
		class CommonFunctions
			@@count = 0
			
			def self.generateId(element, prefix)
				if not element.hasAttribute?('id')
					element.setAttribute('id', prefix + @@count.to_s)
					@@count += 1
				end
			end
			
			def self.setListAttributes(element1, element2, attributes)
				attributes.each() do |attribute|
					if element1.hasAttribute?(attribute)
						element2.setAttribute(attribute, element1.getAttribute(attribute))
					end
				end
			end
			
			def self.increaseInList(list, stringToIncrease)
				if not (((list == nil) or (list.empty?)) or ((stringToIncrease == nil) or (stringToIncrease.empty?)))
					elements = list.split(/[ \n\t\r]+/)
					elements.each() do |element|
						if element == stringToIncrease
							return list
						end
					end
					return "#{list} #{stringToIncrease}"
				elsif (list == nil) or (list.empty?)
					return stringToIncrease
				else
					return list
				end
			end
		end
	end
end