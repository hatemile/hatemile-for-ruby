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

require File.dirname(__FILE__) + '/../AccessibleForm.rb'
require File.dirname(__FILE__) + '/../util/CommonFunctions.rb'

module Hatemile
	module Implementation
		class AccessibleFormImpl < AccessibleForm
			public_class_method :new
			
			def initialize(parser, configure)
				@parser = parser
				@prefixId = configure.getParameter('prefix-generated-ids')
				@classRequiredField = configure.getParameter('class-required-field')
				@sufixRequiredField = configure.getParameter('sufix-required-field')
				@dataIgnore = configure.getParameter('data-ignore')
			end
			
			def fixRequiredField element
				if element.hasAttribute?('required')
					element.setAttribute('aria-required', 'true')
					labels = nil
					if element.hasAttribute?('id')
						labels = @parser.find("label[for=#{element.getAttribute('id')}]").listResults()
					end
					if (labels == nil) or (labels.empty?)
						labels = @parser.find(element).findAncestors('label').listResults()
					end
					labels.each() do |label|
						label.setAttribute('class', Hatemile::Util::CommonFunctions.increaseInList(label.getAttribute('class'), @classRequiredField))
					end
				end
			end
			
			def fixRequiredFields
				elements = @parser.find('[required]').listResults()
				elements.each() do |element|
					if not element.hasAttribute?(@dataIgnore)
						self.fixRequiredField(element)
					end
				end
			end
			
			def fixDisabledField element
				if element.hasAttribute?('disabled')
					element.setAttribute('aria-disabled', 'true')
				end
			end
			
			def fixDisabledFields
				elements = @parser.find('[disabled]').listResults()
				elements.each() do |element|
					if not element.hasAttribute?(@dataIgnore)
						self.fixDisabledField(element)
					end
				end
			end
				
			def fixReadOnlyField element
				if element.hasAttribute?('readonly')
					element.setAttribute('aria-readonly', 'true')
				end
			end
				
			def fixReadOnlyFields
				elements = @parser.find('[readonly]').listResults()
				elements.each() do |element|
					if not element.hasAttribute?(@dataIgnore)
						self.fixReadOnlyField(element)
					end
				end
			end
				
			def fixRangeField element
				if element.hasAttribute?('min')
					element.setAttribute('aria-valuemin', element.getAttribute('min'))
				end
				if element.hasAttribute?('max')
					element.setAttribute('aria-valuemax', element.getAttribute('max'))
				end
			end
				
			def fixRangeFields
				elements = @parser.find('[min],[max]').listResults()
				elements.each() do |element|
					if not element.hasAttribute?(@dataIgnore)
						self.fixRangeField(element)
					end
				end
			end
				
			def fixTextField element
				if (element.getTagName() == 'INPUT') and (element.hasAttribute?('type'))
					type = element.getAttribute('type').downcase
					if (type == 'text') or (type == 'search') or (type == 'email') or (type == 'url') or (type == 'tel') or (type == 'number')
						element.setAttribute('aria-multiline', 'false')
					end
				elsif element.getTagName() == 'TEXTAREA'
					element.setAttribute('aria-multiline', 'true')
				end
			end
				
			def fixTextFields
				elements = @parser.find('input[type=text],input[type=search],input[type=email],input[type=url],input[type=tel],input[type=number],textarea').listResults()
				elements.each() do |element|
					if not element.hasAttribute?(@dataIgnore)
						self.fixTextField(element)
					end
				end
			end
				
			def fixSelectField element
				if element.getTagName() == 'SELECT'
					if element.hasAttribute?('multiple')
						element.setAttribute('aria-multiselectable', 'true')
					else
						element.setAttribute('aria-multiselectable', 'false')
					end
				end
			end
				
			def fixSelectFields
				elements = @parser.find('select').listResults()
				elements.each() do |element|
					if not element.hasAttribute?(@dataIgnore)
						self.fixSelectField(element)
					end
				end
			end
				
			def fixLabel element
				if element.getTagName() == 'LABEL'
					input = nil
					if element.hasAttribute?('for')
						input = @parser.find("##{element.getAttribute('for')}").firstResult()
					else
						input = @parser.find(element).findDescendants('input,select,textarea').firstResult()
						if input != nil
							Hatemile::Util::CommonFunctions.generateId(input, @prefixId)
							element.setAttribute('for', input.getAttribute('id'))
						end
					end
					if input != nil
						if not input.hasAttribute?('aria-label')
							label = element.getTextContent().gsub(/[ \n\r\t]+/, ' ')
							if input.hasAttribute?('aria-required')
								if (input.getAttribute('aria-required').downcase == 'true') and (not label.include?(@sufixRequiredField))
									label += ' ' + @sufixRequiredField
								end
							end
							input.setAttribute('aria-label', label)
						end
						Hatemile::Util::CommonFunctions.generateId(element, @prefixId)
						input.setAttribute('aria-labelledby', Hatemile::Util::CommonFunctions.increaseInList(input.getAttribute('aria-labelledby'), element.getAttribute('id')))
					end
				end
			end
				
			def fixLabels
				elements = @parser.find('label').listResults()
				elements.each() do |element|
					if not element.hasAttribute?(@dataIgnore)
						self.fixLabel(element)
					end
				end
			end
		end
	end
end