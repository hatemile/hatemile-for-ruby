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
		
		##
		# The AccessibleFormImpl class is official implementation of AccessibleForm
		# interface.
		# 
		# ---
		# 
		# Version:
		# 2014-07-23
		class AccessibleFormImpl < AccessibleForm
			public_class_method :new
			
			protected
			
			##
			# Do the label or the aria-label to inform in label that the field is
			# required.
			# 
			# ---
			# 
			# Parameters:
			#  1. Hatemile::Util::HTMLDOMElement +label+ The label.
			#  2. Hatemile::Util::HTMLDOMElement +requiredField+ The required field.
			def fixLabelRequiredField(label, requiredField)
				if (requiredField.hasAttribute?('required')) or ((requiredField.hasAttribute?('aria-required')) \
						and (requiredField.getAttribute('aria-required').downcase() == 'true'))
					if not label.hasAttribute?(@dataLabelRequiredField)
						label.setAttribute(@dataLabelRequiredField, 'true')
					end
					
					if requiredField.hasAttribute?('aria-label')
						contentLabel = requiredField.getAttribute('aria-label')
						if (not @prefixRequiredField.empty?()) and (not contentLabel.include?(@prefixRequiredField))
							contentLabel = "#{@prefixRequiredField} #{contentLabel}"
						end
						if (not @suffixRequiredField.empty?()) and (not contentLabel.include?(@suffixRequiredField))
							contentLabel += " #{@suffixRequiredField}"
						end
						requiredField.setAttribute('aria-label', contentLabel)
					end
				end
			end
			
			##
			# Fix the control to inform if it has autocomplete and the type.
			# 
			# ---
			# 
			# Parameters:
			#  1. Hatemile::Util::HTMLDOMElement +control+ The form control.
			#  2. Boolean +active+ If the element has autocomplete.
			def fixControlAutoComplete(control, active)
				if active
					control.setAttribute('aria-autocomplete', 'both')
				elsif not ((active == nil) and (control.hasAttribute?('aria-autocomplete')))
					if control.hasAttribute?('list')
						list = @parser.find("datalist[id=#{control.getAttribute('list')}]").firstResult()
						if list != nil
							control.setAttribute('aria-autocomplete', 'list')
						end
					end
					if (active == false) and (not control.hasAttribute?('aria-autocomplete') \
							or (not control.getAttribute('aria-autocomplete') == 'list'))
						control.setAttribute('aria-autocomplete', 'none')
					end
				end
			end
			
			public
			
			##
			# Initializes a new object that manipulate the accessibility of the forms
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
				@dataLabelRequiredField = "data-#{configure.getParameter('data-label-required-field')}"
				@dataIgnore = "data-#{configure.getParameter('data-ignore')}"
				@prefixRequiredField = configure.getParameter('prefix-required-field')
				@suffixRequiredField = configure.getParameter('suffix-required-field')
			end
			
			def fixRequiredField(requiredField)
				if requiredField.hasAttribute?('required')
					requiredField.setAttribute('aria-required', 'true')
					
					labels = nil
					if requiredField.hasAttribute?('id')
						labels = @parser.find("label[for=#{requiredField.getAttribute('id')}]").listResults()
					end
					if (labels == nil) or (labels.empty?())
						labels = @parser.find(requiredField).findAncestors('label').listResults()
					end
					labels.each() do |label|
						self.fixLabelRequiredField(label, requiredField)
					end
				end
			end
			
			def fixRequiredFields()
				requiredFields = @parser.find('[required]').listResults()
				requiredFields.each() do |requiredField|
					if not requiredField.hasAttribute?(@dataIgnore)
						self.fixRequiredField(requiredField)
					end
				end
			end
			
			def fixRangeField(rangeField)
				if rangeField.hasAttribute?('min')
					rangeField.setAttribute('aria-valuemin', rangeField.getAttribute('min'))
				end
				if rangeField.hasAttribute?('max')
					rangeField.setAttribute('aria-valuemax', rangeField.getAttribute('max'))
				end
			end
			
			def fixRangeFields()
				rangeFields = @parser.find('[min],[max]').listResults()
				rangeFields.each() do |rangeField|
					if not rangeField.hasAttribute?(@dataIgnore)
						self.fixRangeField(rangeField)
					end
				end
			end
			
			def fixLabel(label)
				if label.getTagName() == 'LABEL'
					if label.hasAttribute?('for')
						field = @parser.find("##{label.getAttribute('for')}").firstResult()
					else
						field = @parser.find(label).findDescendants('input,select,textarea').firstResult()
						
						if field != nil
							Hatemile::Util::CommonFunctions.generateId(field, @prefixId)
							label.setAttribute('for', field.getAttribute('id'))
						end
					end
					if field != nil
						if not field.hasAttribute?('aria-label')
							field.setAttribute('aria-label', label.getTextContent().gsub(/[ \n\r\t]+/, ' '))
						end
						
						self.fixLabelRequiredField(label, field)
						
						Hatemile::Util::CommonFunctions.generateId(label, @prefixId)
						field.setAttribute('aria-labelledby', Hatemile::Util::CommonFunctions
								.increaseInList(field.getAttribute('aria-labelledby'), label.getAttribute('id')))
					end
				end
			end
			
			def fixLabels()
				labels = @parser.find('label').listResults()
				labels.each() do |label|
					if not label.hasAttribute?(@dataIgnore)
						self.fixLabel(label)
					end
				end
			end
			
			def fixAutoComplete(element)
				if element.hasAttribute?('autocomplete')
					value = element.getAttribute('autocomplete')
					if value == 'on'
						active = true
					elsif value == 'off'
						active = false
					end
					if active != nil
						if element.getTagName() == 'FORM'
							controls = @parser.find(element).findDescendants('input,textarea').listResults()
							if element.hasAttribute?('id')
								id = element.getAttribute('id')
								controls = controls.concat(@parser.find("input[form=#{id}],textarea[form=#{id}]")
										.listResults())
							end
							controls.each() do |control|
								fix = true
								if (control.getTagName() == 'INPUT') and (control.hasAttribute?('type'))
									type = control.getAttribute('type').downcase()
									if (type ==	'button') or (type == 'submit') or (type == 'reset') or (type == 'image') \
											or (type == 'file') or (type == 'checkbox') or (type == 'radio') \
											or (type == 'password') or (type == 'hidden')
										fix = false
									end
								end
								if fix
									autoCompleteControlFormValue = control.getAttribute('autocomplete')
									if autoCompleteControlFormValue == 'on'
										self.fixControlAutoComplete(control, true)
									elsif autoCompleteControlFormValue == 'off'
										self.fixControlAutoComplete(control, false)
									else
										self.fixControlAutoComplete(control, active)
									end
								end
							end
						else
							self.fixControlAutoComplete(element, active)
						end
					end
				end
				if (not element.hasAttribute?('aria-autocomplete')) and (element.hasAttribute?('list'))
					self.fixControlAutoComplete(element, nil)
				end
			end
			
			def fixAutoCompletes()
				elements = @parser.find('[autocomplete],[list]').listResults()
				elements.each() do |element|
					if not element.hasAttribute?(@dataIgnore)
						self.fixAutoComplete(element)
					end
				end
			end
		end
	end
end