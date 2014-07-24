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
	# The AccessibleEvent interface fix the problems of accessibility associated
	# with Javascript events in the elements.
	# 
	# ---
	# 
	# Version:
	# 2014-07-23
	class AccessibleEvent
		private_class_method :new
		
		##
		# Fix some problem of accessibility in the events that are called when an
		# element is hovered.
		# 
		# ---
		# 
		# Parameters:
		#  1. Hatemile::Util::HTMLDOMElement +element+ The element that will be fixed.
		# See also:
		#  * {G90: Providing keyboard-triggered event handlers}[http://www.w3.org/TR/WCAG20-TECHS/G90.html]
		#  * {G202: Ensuring keyboard control for all functionality}[http://www.w3.org/TR/WCAG20-TECHS/G202.html]
		#  * {SCR2: Using redundant keyboard and mouse event handlers}[http://www.w3.org/TR/WCAG20-TECHS/SCR2.html]
		#  * {SCR20: Using both keyboard and other device-specific functions}[http://www.w3.org/TR/WCAG20-TECHS/SCR20.html]
		#  * {SCR29: Adding keyboard-accessible actions to static HTML elements}[http://www.w3.org/TR/WCAG20-TECHS/SCR29.html]
		def fixOnHover(element)
		end
		
		##
		# Fix some problem of accessibility in the events that are called when any
		# element of page is hovered.
		# 
		# ---
		# 
		# See also:
		#  * {G90: Providing keyboard-triggered event handlers}[http://www.w3.org/TR/WCAG20-TECHS/G90.html]
		#  * {G202: Ensuring keyboard control for all functionality}[http://www.w3.org/TR/WCAG20-TECHS/G202.html]
		#  * {SCR2: Using redundant keyboard and mouse event handlers}[http://www.w3.org/TR/WCAG20-TECHS/SCR2.html]
		#  * {SCR20: Using both keyboard and other device-specific functions}[http://www.w3.org/TR/WCAG20-TECHS/SCR20.html]
		#  * {SCR29: Adding keyboard-accessible actions to static HTML elements}[http://www.w3.org/TR/WCAG20-TECHS/SCR29.html]
		def fixOnHovers()
		end
		
		##
		# Fix some problem of accessibility in the events that are called when an
		# element is actived.
		# 
		# ---
		# 
		# Parameters:
		#  1. Hatemile::Util::HTMLDOMElement +element+ The element that will be fixed.
		# See also:
		#  * {G90: Providing keyboard-triggered event handlers}[http://www.w3.org/TR/WCAG20-TECHS/G90.html]
		#  * {G202: Ensuring keyboard control for all functionality}[http://www.w3.org/TR/WCAG20-TECHS/G202.html]
		#  * {SCR2: Using redundant keyboard and mouse event handlers}[http://www.w3.org/TR/WCAG20-TECHS/SCR2.html]
		#  * {SCR20: Using both keyboard and other device-specific functions}[http://www.w3.org/TR/WCAG20-TECHS/SCR20.html]
		#  * {SCR29: Adding keyboard-accessible actions to static HTML elements}[http://www.w3.org/TR/WCAG20-TECHS/SCR29.html]
		def fixOnActive(element)
		end
		
		##
		# Fix some problem of accessibility in the events that are called when any
		# element of page is actived.
		# 
		# ---
		# 
		# See also:
		#  * {G90: Providing keyboard-triggered event handlers}[http://www.w3.org/TR/WCAG20-TECHS/G90.html]
		#  * {G202: Ensuring keyboard control for all functionality}[http://www.w3.org/TR/WCAG20-TECHS/G202.html]
		#  * {SCR2: Using redundant keyboard and mouse event handlers}[http://www.w3.org/TR/WCAG20-TECHS/SCR2.html]
		#  * {SCR20: Using both keyboard and other device-specific functions}[http://www.w3.org/TR/WCAG20-TECHS/SCR20.html]
		#  * {SCR29: Adding keyboard-accessible actions to static HTML elements}[http://www.w3.org/TR/WCAG20-TECHS/SCR29.html]
		def fixOnActives()
		end
	end
end