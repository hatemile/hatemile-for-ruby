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

require File.dirname(__FILE__) + '/../AccessibleEvent.rb'
require File.dirname(__FILE__) + '/../util/CommonFunctions.rb'

module Hatemile
	module Implementation
		
		##
		# The AccessibleEventImpl class is official implementation of AccessibleEvent
		# interface.
		# 
		# ---
		# 
		# Version:
		# 2014-07-23
		class AccessibleEventImpl < AccessibleEvent
			public_class_method :new
			
			protected
			
			##
			# Generate the main script in parser.
			def generateMainScript()
				local = @parser.find('head').firstResult()
				if local == nil
					local = @parser.find('body').firstResult()
				end
				if (local != nil) and (@parser.find("##{@idScriptEvent}").firstResult() == nil)
					script = @parser.createElement('script')
					script.setAttribute('id', @idScriptEvent)
					script.setAttribute('type', 'text/javascript')
					javascript = 'function onFocusEvent(e){if(e.onmouseover!=undefined){try{e.onmouseover();}catch(x){}}}function onBlurEvent(e){if(e.onmouseout!=undefined){try{e.onmouseout();}catch(x){}}}function isEnter(k){var n="\\n".charCodeAt(0);var r="\\r".charCodeAt(0);return ((k==n)||(k==r));}function onKeyDownEvent(l,v){if(isEnter(v.keyCode)&&(l.onmousedown!=undefined)){try{l.onmousedown();}catch(x){}}}function onKeyPressEvent(l,v){if(isEnter(v.keyCode)){if(l.onclick!=undefined){try{l.click();}catch(x){}}else if(l.ondblclick!=undefined){try{l.ondblclick();}catch(x){}}}}function onKeyUpEvent(l,v){if(isEnter(v.keyCode)&&(l.onmouseup!=undefined)){try{l.onmouseup();}catch(x){}}}'
					script.appendText(javascript)
					local.appendElement(script)
				end
				@mainScriptAdded = true
			end
			
			##
			# Generate the other scripts in parser.
			def generateOtherScripts()
				local = @parser.find('body').firstResult()
				if local != nil
					@scriptList = @parser.find("##{@idListIdsScriptOnActive}").firstResult()
					if @scriptList == nil
						@scriptList = @parser.createElement('script')
						@scriptList.setAttribute('id', @idListIdsScriptOnActive)
						@scriptList.setAttribute('type', 'text/javascript')
						@scriptList.appendText('var s=[];')
						local.appendElement(@scriptList)
					end
					if @parser.find("##{@idFunctionScriptFixOnActive}").firstResult() == nil
						scriptFunction = @parser.createElement('script')
						scriptFunction.setAttribute('id', @idFunctionScriptFixOnActive)
						scriptFunction.setAttribute('type', 'text/javascript')
						javascript = 'var e;for(var i=0,l=s.length;i<l;i++){e=document.getElementById(s[i]);if(e.onkeypress==undefined){e.onkeypress=function(v){onKeyPressEvent(e,v);};}if(e.onkeyup==undefined){e.onkeyup=function(v){onKeyUpEvent(e,v);};}if(e.onkeydown==undefined){e.onkeydown=function(v){onKeyDownEvent(e,v);};}}'
						scriptFunction.appendText(javascript)
						local.appendElement(scriptFunction)
					end
				end
				@otherScriptsAdded = true
			end
			
			##
			# Add the id of element in list of elements that will have its events
			# modified.
			# 
			# ---
			# 
			# Parameters:
			#  1. Hatemile::Util::HTMLDOMElement +element+ The element with id.
			def addEventInElement(element)
				if not @otherScriptsAdded
					self.generateOtherScripts()
				end
				
				if @scriptList != nil
					Hatemile::Util::CommonFunctions.generateId(element, @prefixId)
					@scriptList.appendText("s.push('#{element.getAttribute('id')}');")
				else
					if not element.hasAttribute?('onkeypress')
						element.setAttribute('onkeypress', 'try{onKeyPressEvent(this,event);}catch(x){}')
					end
					if not element.hasAttribute?('onkeyup')
						element.setAttribute('onkeyup', 'try{onKeyUpEvent(this,event);}catch(x){}')
					end
					if not element.hasAttribute?('onkeydown')
						element.setAttribute('onkeydown', 'try{onKeyDownEvent(this,event);}catch(x){}')
					end
				end
			end
			
			public
			
			##
			# Initializes a new object that manipulate the accessibility of the
			# Javascript events of elements of parser.
			# 
			# ---
			# 
			# Parameters:
			#  1. Hatemile::Util::HTMLDOMParser +parser+ The HTML parser.
			#  2. Hatemile::Util::Configure +configure+ The configuration of HaTeMiLe.
			def initialize(parser, configure)
				@parser = parser
				@prefixId = configure.getParameter('prefix-generated-ids')
				@idScriptEvent = configure.getParameter('id-script-event')
				@idListIdsScriptOnActive = configure.getParameter('id-list-ids-script-onactive')
				@idFunctionScriptFixOnActive = configure.getParameter('id-function-script-fix-onactive')
				@dataIgnore = "data-#{configure.getParameter('data-ignore')}"
				@mainScriptAdded = false
				@otherScriptsAdded = false
				@scriptList = nil
			end
			
			def fixOnHover(element)
				tag = element.getTagName()
				if not ((tag == 'INPUT') or (tag == 'BUTTON') or (tag == 'A') or (tag == 'SELECT') \
						or (tag == 'TEXTAREA') or (element.hasAttribute?('tabindex')))
					element.setAttribute('tabindex', '0')
				end
				
				if not @mainScriptAdded
					self.generateMainScript()
				end
				
				if not element.hasAttribute?('onfocus')
					element.setAttribute('onfocus', 'onFocusEvent(this);')
				end
				if not element.hasAttribute?('onblur')
					element.setAttribute('onblur', 'onBlurEvent(this);')
				end
			end
			
			def fixOnHovers()
				elements = @parser.find('[onmouseover],[onmouseout]').listResults()
				elements.each() do |element|
					if not element.hasAttribute?(@dataIgnore)
						self.fixOnHover(element)
					end
				end
			end
			
			def fixOnActive(element)
				tag = element.getTagName()
				if not ((tag == 'INPUT') or (tag == 'BUTTON') or (tag == 'A'))
					if not ((element.hasAttribute?('tabindex')) or (tag == 'SELECT') or (tag == 'TEXTAREA'))
						element.setAttribute('tabindex', '0')
					end
					
					if not @mainScriptAdded
						self.generateMainScript()
					end
					
					self.addEventInElement(element)
				end
			end
			
			def fixOnActives()
				elements = @parser.find('[onclick],[onmousedown],[onmouseup],[ondblclick]').listResults()
				elements.each() do |element|
					if not element.hasAttribute?(@dataIgnore)
						self.fixOnActive(element)
					end
				end
			end
		end
	end
end