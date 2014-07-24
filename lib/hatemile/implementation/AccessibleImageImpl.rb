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

require File.dirname(__FILE__) + '/../AccessibleImage.rb'
require File.dirname(__FILE__) + '/../util/CommonFunctions.rb'

module Hatemile
	module Implementation
		
		##
		# The AccessibleImageImpl class is official implementation of AccessibleImage
		# interface.
		# 
		# ---
		# 
		# Version:
		# 2014-07-23
		class AccessibleImageImpl < AccessibleImage
			public_class_method :new
			
			##
			# Initializes a new object that manipulate the accessibility of the images
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
				@classListImageAreas = configure.getParameter('class-list-image-areas')
				@classLongDescriptionLink = configure.getParameter('class-longdescription-link')
				@prefixLongDescriptionLink = configure.getParameter('prefix-longdescription-link')
				@suffixLongDescriptionLink = configure.getParameter('suffix-longdescription-link')
				@dataListForImage = "data-#{configure.getParameter('data-list-for-image')}"
				@dataLongDescriptionForImage = "data-#{configure.getParameter('data-longdescription-for-image')}"
				@dataIgnore = "data-#{configure.getParameter('data-ignore')}"
			end
			
			def fixMap(mapElement)
				if mapElement.getTagName() == 'MAP'
					if mapElement.hasAttribute?('name')
						name = mapElement.getAttribute('name')
					elsif mapElement.hasAttribute?('id')
						name = mapElement.getAttribute('id')
					end
					if (name != nil) and (not name.empty?())
						list = @parser.createElement('ul')
						areas = @parser.find(mapElement).findChildren('area[alt]').listResults()
						areas.each() do |area|
							item = @parser.createElement('li')
							anchor = @parser.createElement('a')
							anchor.appendText(area.getAttribute('alt'))
							
							Hatemile::Util::CommonFunctions.setListAttributes(area, anchor, ['href', 'tabindex',
									'target', 'download', 'hreflang', 'media', 'nohref', 'ping', 'rel',
									'type', 'title', 'accesskey', 'name', 'onblur', 'onfocus', 'onmouseout',
									'onmouseover', 'onkeydown', 'onkeypress', 'onkeyup', 'onmousedown',
									'onclick', 'ondblclick', 'onmouseup'])
							
							item.appendElement(anchor)
							list.appendElement(item)
						end
						if list.hasChildren?()
							list.setAttribute('class', @classListImageAreas)
							images = @parser.find("[usemap='##{name}']").listResults()
							images.each() do |image|
								Hatemile::Util::CommonFunctions.generateId(image, @prefixId)
								id = image.getAttribute('id')
								if @parser.find("[#{@dataListForImage}=#{id}]").firstResult() == nil
									newList = list.cloneElement()
									newList.setAttribute(@dataListForImage, id)
									image.insertAfter(newList)
								end
							end
						end
					end
				end
			end
			
			def fixMaps()
				maps = @parser.find('map').listResults()
				maps.each() do |mapElement|
					if not mapElement.hasAttribute?(@dataIgnore)
						self.fixMap(mapElement)
					end
				end
			end
			
			def fixLongDescription(element)
				if element.hasAttribute?('longdesc')
					Hatemile::Util::CommonFunctions.generateId(element, @prefixId)
					id = element.getAttribute('id')
					if @parser.find("[#{@dataLongDescriptionForImage}=#{id}]").firstResult() == nil
						if element.hasAttribute?('alt')
							text = "#{@prefixLongDescriptionLink} #{element.getAttribute('alt')} #{@suffixLongDescriptionLink}"
						else
							text = "#{@prefixLongDescriptionLink} #{@suffixLongDescriptionLink}"
						end
						anchor = @parser.createElement('a')
						anchor.setAttribute('href', element.getAttribute('longdesc'))
						anchor.setAttribute('target', '_blank')
						anchor.setAttribute(@dataLongDescriptionForImage, id)
						anchor.setAttribute('class', @classLongDescriptionLink)
						anchor.appendText(text)
						element.insertAfter(anchor)
					end
				end
			end
			
			def fixLongDescriptions()
				elements = @parser.find('[longdesc]').listResults()
				elements.each() do |element|
					if not element.hasAttribute?(@dataIgnore)
						self.fixLongDescription(element)
					end
				end
			end
		end
	end
end