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
		class AccessibleImageImpl < AccessibleImage
			public_class_method :new
			
			def initialize(parser, configure)
				@parser = parser
				@prefixId = configure.getParameter('prefix-generated-ids')
				@classListImageAreas = configure.getParameter('class-list-image-areas')
				@classLongDescriptionLink = configure.getParameter('class-longdescription-link')
				@textLongDescriptionLink = configure.getParameter('text-longdescription-link')
				@dataListForImage = configure.getParameter('data-list-for-image')
				@dataLongDescriptionForImage = configure.getParameter('data-longdescription-for-image')
				@dataIgnore = configure.getParameter('data-ignore')
			end
			
			def fixMap(element)
				if element.getTagName() == 'MAP'
					name = nil
					if element.hasAttribute?('name')
						name = element.getAttribute('name')
					elsif element.hasAttribute?('id')
						name = element.getAttribute('id')
					end
					if (name != nil) and (not name.empty?)
						list = @parser.createElement('ul')
						list.setAttribute('class', @classListImageAreas)
						areas = @parser.find(element).findChildren('area, a').listResults()
						areas.each() do |area|
							if area.hasAttribute?('alt')
								item = @parser.createElement('li')
								anchor = @parser.createElement('a')
								anchor.appendText(area.getAttribute('alt'))
								Hatemile::Util::CommonFunctions.setListAttributes(area, anchor, ['href',
										'target', 'download', 'hreflang', 'media',
										'rel', 'type', 'title'])
								item.appendElement(anchor)
								list.appendElement(item)
							end
						end
						if list.hasChildren?()
							images = @parser.find("[usemap='##{name}']").listResults()
							images.each() do |image|
								Hatemile::Util::CommonFunctions.generateId(image, @prefixId)
								if @parser.find("[#{@dataListForImage}=#{image.getAttribute('id')}]").firstResult() == nil
									newList = list.cloneElement()
									newList.setAttribute(@dataListForImage, image.getAttribute('id'))
									image.insertAfter(newList)
								end
							end
						end
					end
				end
			end
			
			def fixMaps()
				elements = @parser.find('map').listResults()
				elements.each() do |element|
					if not element.hasAttribute?(@dataIgnore)
						self.fixMap(element)
					end
				end
			end
			
			def fixLongDescription(element)
				if element.hasAttribute?('longdesc')
					Hatemile::Util::CommonFunctions.generateId(element, @prefixId)
					if @parser.find("[#{@dataLongDescriptionForImage}=#{element.getAttribute('id')}]").firstResult() == nil
						text = nil
						if element.hasAttribute?('alt')
							text = "#{element.getAttribute('alt')} #{@textLongDescriptionLink}"
						else
							text = @textLongDescriptionLink
						end
						longDescription = element.getAttribute('longdesc')
						anchor = @parser.createElement('a')
						anchor.setAttribute('href', longDescription)
						anchor.setAttribute('target', '_blank')
						anchor.setAttribute(@dataLongDescriptionForImage, element.getAttribute('id'))
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