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
		
		##
		# The CommonFuncionts class contains the used methods by HaTeMiLe classes.
		# 
		# ---
		# 
		# Version:
		# 2014-07-23
		class CommonFunctions
			private_class_method :new
			
			##
			# Integer Count the number of ids created.
			@@count = 0
			
			##
			# Generate a id for a element.
			# 
			# ---
			# 
			# Parameters:
			#  1. Hatemile::Util::HTMLDOMElement +element+ The element.
			#  2. String +prefix+ The prefix of id.
			def self.generateId(element, prefix)
				if not element.hasAttribute?('id')
					element.setAttribute('id', prefix + @@count.to_s())
					@@count += 1
				end
			end
			
			##
			# Copy a list of attributes of a element for other element.
			# 
			# ---
			# 
			# Parameters:
			#  1. Hatemile::Util::HTMLDOMElement +element1+ The element that have attributes copied.
			#  2. Hatemile::Util::HTMLDOMElement +element2+ The element that copy the attributes.
			#  3. Array(String) +attributes+ The list of attributes that will be copied.
			# 
			def self.setListAttributes(element1, element2, attributes)
				attributes.each() do |attribute|
					if element1.hasAttribute?(attribute)
						element2.setAttribute(attribute, element1.getAttribute(attribute))
					end
				end
			end
			
			##
			# Increase a item in a HTML list.
			# 
			# ---
			# 
			# Parameters:
			#  1. String +list+ The HTML list.
			#  2. String +stringToIncrease+ The value of item.
			# Return:
			# String The HTML list with the item added, if the item not was contained
			# in list.
			def self.increaseInList(list, stringToIncrease)
				if (list != nil) and (not list.empty?()) and (stringToIncrease != nil) and (not stringToIncrease.empty?())
					elements = list.split(/[ \n\t\r]+/)
					elements.each() do |element|
						if element == stringToIncrease
							return list
						end
					end
					return "#{list} #{stringToIncrease}"
				elsif (list != nil) and (not list.empty?())
					return list
				else
					return stringToIncrease
				end
			end
		end
	end
end