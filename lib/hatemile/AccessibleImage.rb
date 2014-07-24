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
	# The AccessibleImage interface fix the problems of accessibility associated
	# with the images.
	# 
	# ---
	# 
	# Version:
	# 2014-07-23
	class AccessibleImage
		private_class_method :new
		
		##
		# Fix the map of images.
		# 
		# ---
		# 
		# Parameters:
		#  1. Hatemile::Util::HTMLDOMElement +map+ The map of images.
		# See also:
		#  * {WCAG 1.0 Checkpoint 1.5}[http://www.w3.org/TR/WAI-WEBCONTENT-TECHS/#tech-redundant-client-links]
		def fixMap(map)
		end
		
		##
		# Fix the maps of images.
		# 
		# ---
		# 
		# See also:
		#  * {WCAG 1.0 Checkpoint 1.5}[http://www.w3.org/TR/WAI-WEBCONTENT-TECHS/#tech-redundant-client-links]
		def fixMaps()
		end
		
		##
		# Fix the element with long description.
		# 
		# ---
		# 
		# Parameters:
		#  1. Hatemile::Util::HTMLDOMElement +element+ The element with long description.
		# See also:
		#  * {G73: Providing a long description in another location with a link to it that is immediately adjacent to the non-text content}[http://www.w3.org/TR/WCAG20-TECHS/G73.html]
		#  * {G74: Providing a long description in text near the non-text content, with a reference to the location of the long description in the short description}[http://www.w3.org/TR/WCAG20-TECHS/G74.html]
		def fixLongDescription(element)
		end
		
		##
		# Fix the elements with longs descriptions.
		# 
		# ---
		# 
		# See also:
		#  * {G73: Providing a long description in another location with a link to it that is immediately adjacent to the non-text content}[http://www.w3.org/TR/WCAG20-TECHS/G73.html]
		#  * {G74: Providing a long description in text near the non-text content, with a reference to the location of the long description in the short description}[http://www.w3.org/TR/WCAG20-TECHS/G74.html]
		def fixLongDescriptions()
		end
	end
end