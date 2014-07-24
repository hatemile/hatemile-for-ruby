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
	
	##
	# The AccessibleTable interface fix the problems of accessibility associated
	# with the tables.
	# 
	# ---
	# 
	# Version:
	# 2014-07-23
	class AccessibleTable
		private_class_method :new
		
		##
		# Fix the table.
		# 
		# ---
		# 
		# Parameters:
		#  1. Hatemile::Util::HTMLDOMElement +table+ The table.
		# See also:
		#  * {H43: Using id and headers attributes to associate data cells with header cells in data tables}[http://www.w3.org/TR/WCAG20-TECHS/H43.html]
		#  * {H63: Using the scope attribute to associate header cells and data cells in data tables}[http://www.w3.org/TR/WCAG20-TECHS/H63.html]
		def fixTable(table)
		end
		
		##
		# Fix the tables.
		# 
		# ---
		# 
		# See also:
		#  * {H43: Using id and headers attributes to associate data cells with header cells in data tables}[http://www.w3.org/TR/WCAG20-TECHS/H43.html]
		#  * {H63: Using the scope attribute to associate header cells and data cells in data tables}[http://www.w3.org/TR/WCAG20-TECHS/H63.html]
		def fixTables()
		end
	end
end