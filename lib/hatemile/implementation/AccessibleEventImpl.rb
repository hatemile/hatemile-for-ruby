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
		class AccessibleEventImpl < AccessibleEvent
			public_class_method :new
			
			protected
			def initialize(parser, configure)
				@parser = parser
				@prefixId = configure.getParameter('prefix-generated-ids')
				@idScriptEvent = configure.getParameter('id-script-event')
				@idListIdsScriptOnClick = configure.getParameter('id-list-ids-script-onclick')
				@idFunctionScriptFixOnClick = configure.getParameter('id-function-script-fix-onclick')
				@dataFocused = configure.getParameter('data-focused')
				@dataPressed = configure.getParameter('data-pressed')
				@dataIgnore = configure.getParameter('data-ignore')
				@mainScriptAdded = false
				@otherScriptsAdded = false
				@scriptList = nil
			end
			
			def generateMainScript()
				if @parser.find("##{@idScriptEvent}").firstResult() == nil
					script = @parser.createElement('script')
					script.setAttribute('id', @idScriptEvent)
					script.setAttribute('type', 'text/javascript')
					javascript = "\nfunction onFocusEvent(element) {
						element.setAttribute('#{@dataFocused}', 'true');
						if (element.onmouseover != undefined) {
							element.onmouseover();
						}
					}
					function onBlurEvent(element) {
						if (element.hasAttribute('#{@dataFocused}')) {
							if ((element.getAttribute('#{@dataFocused}').toLowerCase() == 'true') && (element.onmouseout != undefined)) {
								element.onmouseout();
							}
							element.setAttribute('#{@dataFocused}', 'false');
						}
					}
					function onKeyPressEvent(element, event) {
						element.setAttribute('#{@dataPressed}', event.keyCode);
					}
					function onKeyPressUp(element, event) {
						var key = event.keyCode;
						var enter1 = \"\\n\".charCodeAt(0);
						var enter2 = \"\\r\".charCodeAt(0);
						if ((key == enter1) || (key == enter2)) {
							if (element.hasAttribute('#{@dataPressed}')) {
								if (key == parseInt(element.getAttribute('#{@dataPressed}'))) {
									if (element.onclick != undefined) {
										element.click();
									}
									element.removeAttribute('#{@dataPressed}');
								}
							}
						}
					}";
					script.appendText(javascript)
					local = @parser.find('head').firstResult()
					if local == nil
						local = @parser.find('body').firstResult()
					end
					local.appendElement(script)
				end
			end
			
			def generateOtherScripts()
				@scriptList = @parser.find("##{@idListIdsScriptOnClick}").firstResult()
				if @scriptList == nil
					@scriptList = @parser.createElement('script')
					@scriptList.setAttribute('id', @idListIdsScriptOnClick)
					@scriptList.setAttribute('type', 'text/javascript')
					@scriptList.appendText("\nidsElementsWithOnClick = [];\n")
					@parser.find('body').firstResult().appendElement(@scriptList)
				end
				if @parser.find("##{@idFunctionScriptFixOnClick}").firstResult() == nil
					scriptFunction = @parser.createElement('script')
					scriptFunction.setAttribute('id', @idFunctionScriptFixOnClick)
					scriptFunction.setAttribute('type', 'text/javascript')
					javascript = "\nfor (var i = 0, length = idsElementsWithOnClick.length; i < length; i++) {
						var element = document.getElementById(idsElementsWithOnClick[i]);
						element.onkeypress = function(event) {
							onKeyPressEvent(element, event);
						};
						element.onkeyup = function(event) {
							onKeyPressUp(element, event);
						};
					}"
					scriptFunction.appendText(javascript)
					@parser.find('body').firstResult().appendElement(scriptFunction)
				end
				@otherScriptsAdded = true
			end
			
			def addElementIdWithOnClick(id)
				@scriptList.appendText("idsElementsWithOnClick.push('#{id}');\n")
			end
			
			public
			def fixOnHover(element)
				if not @mainScriptAdded
					self.generateMainScript()
				end
				tag = element.getTagName()
				if not (tag == 'INPUT' or tag == 'BUTTON' or tag == 'A' or tag == 'SELECT' or tag == 'TEXTAREA' or element.hasAttribute?('tabindex'))
					element.setAttribute('tabindex', '0')
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
					if (!element.hasAttribute?(@dataIgnore))
						self.fixOnHover(element)
					end
				end
			end
			
			def fixOnClick(element)
				tag = element.getTagName()
				if not (tag == 'INPUT' or tag == 'BUTTON' or tag == 'A')
					if not @mainScriptAdded
						self.generateMainScript()
					end
					if not @otherScriptsAdded
						self.generateOtherScripts()
					end
					if not (element.hasAttribute?('tabindex') or tag == 'SELECT' or tag == 'TEXTAREA')
						element.setAttribute('tabindex', '0')
					end
					Hatemile::Util::CommonFunctions.generateId(element, @prefixId)
					if (not element.hasAttribute?('onkeypress')) and (not element.hasAttribute?('onkeyup')) and (not element.hasAttribute?('onkeydown'))
						self.addElementIdWithOnClick(element.getAttribute('id'))
					end
				end
			end
			
			def fixOnClicks()
				elements = @parser.find('[onclick]').listResults()
				elements.each() do |element|
					if not element.hasAttribute?(@dataIgnore)
						self.fixOnClick(element)
					end
				end
			end
		end
	end
end