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

require File.dirname(__FILE__) + '/../AccessibleShortcut.rb'

module Hatemile
	module Implementation
		
		##
		# The AccessibleShortcutImpl class is official implementation of
		# AccessibleShortcut interface.
		# 
		# ---
		# 
		# Version:
		# 2014-07-30
		class AccessibleShortcutImpl < AccessibleShortcut
			public_class_method :new
			
			protected
			
			##
			# Returns the description of element.
			# 
			# ---
			# 
			# Parameters:
			#  1. Hatemile::Util::HTMLDOMElement +element+ The element with description.
			# Return:
			# String The description of element.
			def getDescription(element)
				description = nil
				if element.hasAttribute?('title')
					description = element.getAttribute('title')
				elsif element.hasAttribute?('aria-label')
					description = element.getAttribute('aria-label')
				elsif element.hasAttribute?('alt')
					description = element.getAttribute('alt')
				elsif element.hasAttribute?('label')
					description = element.getAttribute('label')
				elsif (element.hasAttribute?('aria-labelledby')) or (element.hasAttribute?('aria-describedby'))
					if element.hasAttribute?('aria-labelledby')
						descriptionIds = element.getAttribute('aria-labelledby').split(/[ \n\t\r]+/)
					else
						descriptionIds = element.getAttribute('aria-describedby').split(/[ \n\t\r]+/)
					end
					descriptionIds.each() do |descriptionId|
						elementDescription = @parser.find("##{descriptionId}").firstResult()
						if elementDescription != nil
							description = elementDescription.getTextContent()
							break
						end
					end
				elsif element.getTagName() == 'INPUT'
					type = element.getAttribute('type').downcase()
					if ((type == 'button') or (type == 'submit') or (type == 'reset')) and element.hasAttribute?('value')
						description = element.getAttribute('value')
					end
				end
				if description == nil
					description = element.getTextContent()
				end
				return description.gsub(/[ \n\t\r]+/, ' ')
			end
			
			##
			# Generate the list of shortcuts of page.
			# 
			# ---
			# 
			# Return:
			# Array<String> The list of shortcuts of page.
			def generateList()
				local = @parser.find('body').firstResult()
				htmlList = nil
				if local != nil
					container = @parser.find("##{@idContainerShortcuts}").firstResult()
					if container == nil
						container = @parser.createElement('div')
						container.setAttribute('id', @idContainerShortcuts)
						firstChild = local.getFirstElementChild()
						firstChild.insertBefore(container)
						
						anchorJump = @parser.createElement('a')
						anchorJump.setAttribute('id', @idSkipLinkContainerShortcuts)
						anchorJump.setAttribute('href', "##{@idSkipContainerShortcuts}")
						anchorJump.appendText(@textSkipLinkContainerShortcuts)
						container.insertBefore(anchorJump)
						
						anchor = @parser.createElement('a')
						anchor.setAttribute('name', @idSkipContainerShortcuts)
						anchor.setAttribute('id', @idSkipContainerShortcuts)
						firstChild.insertBefore(anchor)
						
						textContainer = @parser.createElement('span')
						textContainer.setAttribute('id', @idTextShortcuts)
						textContainer.appendText(@textShortcuts)
						container.appendElement(textContainer)
					end
					htmlList = @parser.find(container).findChildren('ul').firstResult()
					if htmlList == nil
						htmlList = @parser.createElement('ul')
						container.appendElement(htmlList)
					end
				end
				@listAdded = true
				
				return htmlList
			end
			
			public
			
			##
			# Initializes a new object that manipulate the accessibility of the
			# shortcuts of parser.
			# 
			# ---
			# 
			# Parameters:
			#  1. Hatemile::Util::HTMLDOMParser +parser+ The HTML parser.
			#  2. Hatemile::Util::Configure +configure+ The configuration of HaTeMiLe. 
			#  3. String +userAgent+ The user agent of the user.
			def initialize(parser, configure, userAgent = nil)
				@parser = parser
				@idContainerShortcuts = configure.getParameter('id-container-shortcuts')
				@idSkipLinkContainerShortcuts = configure.getParameter('id-skip-link-container-shortcuts')
				@idSkipContainerShortcuts = configure.getParameter('id-skip-container-shortcuts')
				@idTextShortcuts = configure.getParameter('id-text-shortcuts')
				@textSkipLinkContainerShortcuts = configure.getParameter('text-skip-container-shortcuts')
				@textShortcuts = configure.getParameter('text-shortcuts')
				@standartPrefix = configure.getParameter('text-standart-shortcut-prefix')
				@dataAccessKey = "data-#{configure.getParameter('data-accesskey')}"
				@dataIgnore = "data-#{configure.getParameter('data-ignore')}"
				@listAdded = false
				
				if userAgent != nil
					userAgent = userAgent.downcase()
					opera = userAgent.include?('opera')
					mac = userAgent.include?('mac')
					konqueror = userAgent.include?('konqueror')
					spoofer = userAgent.include?('spoofer')
					safari = userAgent.include?('applewebkit')
					windows = userAgent.include?('windows')
					chrome = userAgent.include?('chrome')
					firefox = userAgent.match('firefox/[2-9]|minefield/3') != nil
					ie = userAgent.include?('msie') or userAgent.include?('trident')
					
					if opera
						@prefix = 'SHIFT + ESC'
					elsif chrome and mac and (not spoofer)
						@prefix = 'CTRL + OPTION'
					elsif safari and (not windows) and (not spoofer)
						@prefix = 'CTRL + ALT'
					elsif (not windows) and (safari or mac or konqueror)
						@prefix = 'CTRL'
					elsif firefox
						@prefix = 'ALT + SHIFT'
					elsif chrome or ie
						@prefix = 'ALT'
					else
						@prefix = @standartPrefix
					end
				else
					@prefix = @standartPrefix
				end
			end
			
			def getPrefix()
				return @prefix
			end
			
			def fixShortcut(element)
				if element.hasAttribute?('accesskey')
					description = self.getDescription(element)
					if not element.hasAttribute?('title')
						element.setAttribute('title', description)
					end
					
					if not @listAdded
						@list = self.generateList()
					end
					
					if @list != nil
						keys = element.getAttribute('accesskey').split(/[ \n\t\r]+/)
						keys.each() do |key|
							key = key.upcase()
							if @parser.find(@list).findChildren("[#{@dataAccessKey}=#{key}]").firstResult() == nil
								item = @parser.createElement('li')
								item.setAttribute(@dataAccessKey, key)
								item.appendText("#{@prefix} + #{key}: #{description}")
								@list.appendElement(item)
							end
						end
					end
				end
			end
			
			def fixShortcuts()
				elements = @parser.find('[accesskey]').listResults()
				elements.each() do |element|
					if not element.hasAttribute?(@dataIgnore)
						self.fixShortcut(element)
					end
				end
			end
		end
	end
end