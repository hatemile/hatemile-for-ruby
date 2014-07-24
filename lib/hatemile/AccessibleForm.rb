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
	# The AccessibleForm interface fix the problems of accessibility associated
	# with the forms.
	# 
	# ---
	# 
	# Version:
	# 2014-07-23
	class AccessibleForm
		private_class_method :new
		
		##
		# Fix required field.
		# 
		# ---
		# 
		# Parameters:
		#  1. Hatemile::Util::HTMLDOMElement +requiredField+ The element that will be fixed.
		# See also:
		#  * {H90: Indicating required form controls using label or legend}[http://www.w3.org/TR/WCAG20-TECHS/H90.html]
		#  * {ARIA2: Identifying a required field with the aria-required property}[http://www.w3.org/TR/2014/NOTE-WCAG20-TECHS-20140311/ARIA2]
		#  * {F81: Failure of Success Criterion 1.4.1 due to identifying required or error fields using color differences only}[http://www.w3.org/TR/WCAG20-TECHS/F81.html]
		#  * {aria-required (property) | Supported States and Properties}[http://www.w3.org/TR/wai-aria/states_and_properties#aria-required]
		def fixRequiredField(requiredField)
		end
		
		##
		# Fix required fields.
		# 
		# ---
		#
		# See also:
		#  * {H90: Indicating required form controls using label or legend}[http://www.w3.org/TR/WCAG20-TECHS/H90.html]
		#  * {ARIA2: Identifying a required field with the aria-required property}[http://www.w3.org/TR/2014/NOTE-WCAG20-TECHS-20140311/ARIA2]
		#  * {F81: Failure of Success Criterion 1.4.1 due to identifying required or error fields using color differences only}[http://www.w3.org/TR/WCAG20-TECHS/F81.html]
		#  * {aria-required (property) | Supported States and Properties}[http://www.w3.org/TR/wai-aria/states_and_properties#aria-required]
		def fixRequiredFields()
		end
		
		##
		# Fix range field.
		# 
		# ---
		# 
		# Parameters:
		#  1. Hatemile::Util::HTMLDOMElement +rangeField+ The element that will be fixed.
		# See also:
		#  * {aria-valuemin (property) | Supported States and Properties}[http://www.w3.org/TR/wai-aria/states_and_properties#aria-valuemin]
		#  * {aria-valuemax (property) | Supported States and Properties}[http://www.w3.org/TR/wai-aria/states_and_properties#aria-valuemax]
		#  * {Using WAI-ARIA range attributes for range widgets such as progressbar, scrollbar, slider and spinbutton}[http://www.w3.org/WAI/GL/wiki/Using_WAI-ARIA_range_attributes_for_range_widgets_such_as_progressbar,_scrollbar,_slider,_and_spinbutton]
		#  * {ARIA3: Identifying valid range information with the aria-valuemin and aria-valuemax properties}[http://www.w3.org/WAI/GL/2013/WD-WCAG20-TECHS-20130711/ARIA3.html]
		def fixRangeField(rangeField)
		end
		
		##
		# Fix range fields.
		# 
		# ---
		# 
		# See also:
		#  * {aria-valuemin (property) | Supported States and Properties}[http://www.w3.org/TR/wai-aria/states_and_properties#aria-valuemin]
		#  * {aria-valuemax (property) | Supported States and Properties}[http://www.w3.org/TR/wai-aria/states_and_properties#aria-valuemax]
		#  * {Using WAI-ARIA range attributes for range widgets such as progressbar, scrollbar, slider and spinbutton}[http://www.w3.org/WAI/GL/wiki/Using_WAI-ARIA_range_attributes_for_range_widgets_such_as_progressbar,_scrollbar,_slider,_and_spinbutton]
		#  * {ARIA3: Identifying valid range information with the aria-valuemin and aria-valuemax properties}[http://www.w3.org/WAI/GL/2013/WD-WCAG20-TECHS-20130711/ARIA3.html]
		def fixRangeFields()
		end
		
		##
		# Fix field associated with the label.
		# 
		# ---
		# 
		# Parameters:
		#  1. Hatemile::Util::HTMLDOMElement +label+ The element that will be fixed.
		# See also:
		#  * {aria-label (property) | Supported States and Properties}[http://www.w3.org/TR/wai-aria/states_and_properties#aria-label]
		#  * {aria-labelledby (property) | Supported States and Properties}[http://www.w3.org/TR/wai-aria/states_and_properties#aria-labelledby]
		def fixLabel(label)
		end
		
		##
		# Fix fields associated with the labels.
		# 
		# ---
		# 
		# See also:
		#  * {aria-label (property) | Supported States and Properties}[http://www.w3.org/TR/wai-aria/states_and_properties#aria-label]
		#  * {aria-labelledby (property) | Supported States and Properties}[http://www.w3.org/TR/wai-aria/states_and_properties#aria-labelledby]
		def fixLabels()
		end
		
		##
		# Fix element to inform if has autocomplete and the type.
		# 
		# ---
		# 
		# Parameters:
		#  1. Hatemile::Util::HTMLDOMElement +element+ The element that will be fixed.
		# See also:
		#  * {aria-autocomplete (property) | Supported States and Properties}[http://www.w3.org/TR/wai-aria/states_and_properties#aria-autocomplete]
		def fixAutoComplete(element)
		end
		
		##
		# Fix elements to inform if has autocomplete and the type.
		# 
		# ---
		# 
		# See also:
		#  * {aria-autocomplete (property) | Supported States and Properties}[http://www.w3.org/TR/wai-aria/states_and_properties#aria-autocomplete]
		def fixAutoCompletes()
		end
	end
end