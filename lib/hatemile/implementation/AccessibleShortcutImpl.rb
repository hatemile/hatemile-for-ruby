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
		class AccessibleShortcutImpl < AccessibleShortcut
			public_class_method :new
			
			def initialize(parser, configure, userAgent)
				@parser = parser
				@idContainerShortcuts = configure.getParameter('id-container-shortcuts')
				@idSkipLinkContainerShortcuts = configure.getParameter('id-skip-link-container-shortcuts')
				@idSkipContainerShortcuts = configure.getParameter('id-skip-container-shortcuts')
				@dataAccessKey = configure.getParameter('data-accesskey')
				@textSkipLinkContainerShortcuts = configure.getParameter('text-skip-container-shortcuts')
				@dataIgnore = configure.getParameter('data-ignore')

				if userAgent != nil
					userAgent = userAgent.downcase()
					mac = userAgent.include?('mac')
					konqueror = userAgent.include?('konqueror')
					spoofer = userAgent.include?('spoofer')
					safari = userAgent.include?('applewebkit')
					windows = userAgent.include?('windows')
					if userAgent.include?('opera')
						@prefix = 'SHIFT + ESC'
					elsif userAgent.include?('chrome') and (not spoofer) and mac
						@prefix = 'CTRL + OPTION'
					elsif safari and (not windows) and (not spoofer)
						@prefix = 'CTRL + ALT'
					elsif (not windows) and (safari or mac or konqueror)
						@prefix = 'CTRL'
					elsif userAgent.match('firefox/[2-9]|minefield/3') != nil
						@prefix = 'ALT + SHIFT'
					else
						@prefix = 'ALT'
					end
				else
					@prefix = 'ALT'
				end
			end
			
			protected
			def getDescription(element)
				description = ''
				if element.hasAttribute?('title')
					description = element.getAttribute('title')
				elsif element.hasAttribute?('aria-labelledby')
					labelsIds = element.getAttribute('aria-labelledby').split(/[ \n\t\r]+/)
					labelsIds.each() do |labelId|
						label = @parser.find("##{labelId}").firstResult()
						if label != nil
							description = label.getTextContent()
							break
						end
					end
				elsif element.hasAttribute?('aria-label')
					description = element.getAttribute('aria-label')
				elsif element.hasAttribute?('alt')
					description = element.getAttribute('alt')
				elsif element.getTagName() == 'INPUT'
					type = element.getAttribute('type').downcase()
					if ((type == 'button') or (type == 'submit') or (type == 'reset')) and element.hasAttribute?('value')
						description = element.getAttribute('value')
					end
				else
					description = element.getTextContent()
				end
				return description.gsub(/[ \n\t\r]+/, ' ')
			end
			
			def generateList()
				container = @parser.find("##{@idContainerShortcuts}").firstResult()
				if container == nil
					container = @parser.createElement('div')
					container.setAttribute('id', @idContainerShortcuts)
					firstChild = @parser.find('body').firstResult().getFirstElementChild()
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
				end
				htmlList = @parser.find(container).findChildren('ul').firstResult()
				if htmlList == nil
					htmlList = @parser.createElement('ul')
					container.appendElement(htmlList)
				end
				return htmlList
			end
			
			public
			def getPrefix()
				return @prefix
			end
			
			def fixShortcut(element)
				if element.hasAttribute?('accesskey')
					description = self.getDescription(element)
					if not element.hasAttribute?('title')
						element.setAttribute('title', description)
					end
					keys = element.getAttribute('accesskey').split(/[ \n\t\r]+/)
					if @list == nil
						@list = self.generateList()
					end
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