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
		
		##
		# The Configure class contains the configuration of HaTeMiLe.
		# 
		# ---
		# 
		# Version:
		# 2014-07-23
		class Configure
			
			##
			# Initializes a new object that contains the configuration of HaTeMiLe.
			# 
			# ---
			# 
			# Parameters:
			#  1. String +fileName+ The full path of file.
			def initialize(fileName = nil)
				@parameters = Hash.new()
				@selectorChanges = Array.new()
				if (fileName == nil)
					fileName = './hatemile-configure.xml'
				end
				document = REXML::Document.new(File.read(fileName))
				document.elements.each('configure/parameters/parameter') do |parameter|
					if parameter.text().class() != NilClass
						@parameters[parameter.attribute('name').value()] = parameter.text()
					else
						@parameters[parameter.attribute('name').value()] = ''
					end
				end
				document.elements.each('configure/selector-changes/selector-change') do |selectorChange|
					@selectorChanges.push(SelectorChange.new(selectorChange.attribute('selector').value(), selectorChange.attribute('attribute').value(), selectorChange.attribute('value-attribute').value()))
				end
			end
			
			##
			# Returns the parameters of configuration.
			# 
			# ---
			# 
			# Return:
			# Hash(String, String) The parameters of configuration.
			def getParameters()
				return @parameters.clone()
			end
			
			##
			# Returns the value of a parameter of configuration.
			# 
			# ---
			# 
			# Parameters:
			#  1. String +parameter+ The parameter.
			# Return:
			# String The value of the parameter.
			def getParameter(parameter)
				return @parameters[parameter]
			end
			
			##
			# Returns the changes that will be done in selectors.
			# 
			# ---
			# 
			# Return:
			# Array(SelectorChange) The changes that will be done in selectors.
			def getSelectorChanges()
				return @selectorChanges.clone()
			end
		end
	end
end