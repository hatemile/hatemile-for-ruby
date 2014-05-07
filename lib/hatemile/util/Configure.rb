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

require 'rexml/document'
require File.dirname(__FILE__) + '/SelectorChange.rb'

module Hatemile
	module Util
		class Configure
			def initialize(fileName = nil)
				@parameters = Hash.new()
				@selectorChanges = Array.new()
				if (fileName == nil)
					fileName = './hatemile-configure.xml'
				end
				document = REXML::Document.new(File.read(fileName))
				document.elements.each('configure/parameters/parameter') do |parameter|
					@parameters[parameter.attribute('name').value()] = parameter.text()
				end
				document.elements.each('configure/selector-changes/selector-change') do |selectorChange|
					@selectorChanges.push(SelectorChange.new(selectorChange.attribute('selector'), selectorChange.attribute('attribute'), selectorChange.attribute('value-attribute')))
				end
			end
				
			def getParameter(parameter)
				return @parameters[parameter]
			end
				
			def getSelectorChanges()
				return @selectorChanges
			end
		end
	end
end