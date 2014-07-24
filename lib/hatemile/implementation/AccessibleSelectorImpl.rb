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

require File.dirname(__FILE__) + '/../AccessibleSelector.rb'

module Hatemile
	module Implementation
		
		##
		# The AccessibleSelectorImpl class is official implementation of
		# AccessibleSelector interface.
		# 
		# ---
		# 
		# Version:
		# 2014-07-23
		class AccessibleSelectorImpl < AccessibleSelector
			public_class_method :new
			
			##
			# Initializes a new object that manipulate the accessibility through of the
			# selectors of the configuration file.
			# 
			# ---
			# 
			# Parameters:
			#  1. Hatemile::Util::HTMLDOMParser +parser+ The HTML parser.
			#  2. Hatemile::Util::Configure +configure+ The configuration of HaTeMiLe.
			def initialize(parser, configure)
				@parser = parser
				@changes = configure.getSelectorChanges()
				@dataIgnore = "data-#{configure.getParameter('data-ignore')}"
			end
			
			def fixSelectors()
				@changes.each() do |change|
					elements = @parser.find(change.getSelector).listResults()
					elements.each() do |element|
						if not element.hasAttribute?(@dataIgnore)
							element.setAttribute(change.getAttribute(), change.getValueForAttribute())
						end
					end
				end
			end
		end
	end
end