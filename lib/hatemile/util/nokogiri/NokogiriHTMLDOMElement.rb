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

require File.dirname(__FILE__) + '/../HTMLDOMElement.rb'
require File.dirname(__FILE__) + '/NokogiriAuxiliarToString.rb'

module Hatemile
	module Util
		module NokogiriLib
			
			##
			# The NokogiriHTMLDOMElement class is official implementation of HTMLDOMElement
			# interface for the Nokogiri library.
			# 
			# ---
			# 
			# Version:
			# 2014-07-30
			class NokogiriHTMLDOMElement < Hatemile::Util::HTMLDOMElement
				public_class_method :new
				
				##
				# Initializes a new object that encapsulate the Nokogiri Node.
				# 
				# ---
				# 
				# Parameters:
				#  1. Nokogiri::XML::Node +element+ The Nokogiri Node.
				def initialize(element)
					@data = element
				end
				
				def getTagName()
					return @data.name.upcase()
				end
				
				def getAttribute(name)
					return @data.get_attribute(name)
				end
				
				def setAttribute(name, value)
					@data.set_attribute(name, value)
				end
				
				def removeAttribute(name)
					if self.hasAttribute?(name)
						@data.remove_attribute(name)
					end
				end
				
				def hasAttribute?(name)
					return @data.attributes[name] != nil
				end
				
				def hasAttributes?()
					return (not @data.attributes.empty?())
				end
				
				def getTextContent()
					return @data.text()
				end
				
				def insertBefore(newElement)
					@data.before(newElement.getData())
					return newElement
				end
				
				def insertAfter(newElement)
					@data.after(newElement.getData())
					return newElement
				end
				
				def removeElement()
					@data.remove()
					return self
				end
				
				def replaceElement(newElement)
					@data.replace(newElement.getData())
					return newElement
				end
				
				def appendElement(element)
					@data.add_child(element.getData())
					return element
				end
				
				def getChildren()
					array = Array.new()
					@data.children() do |child|
						if child.element?()
							array.push(NokogiriHTMLDOMElement.new(child))
						end
					end
					return array
				end
				
				def appendText(text)
					@data.add_child(Nokogiri::XML::Text.new(text, @data.document))
				end
				
				def hasChildren?()
					return @data.children().empty?() == false
				end
				
				def getParentElement()
					parent = @data.parent()
					if (parent != nil) and (parent.element?())
						return NokogiriHTMLDOMElement.new(parent)
					else
						return nil
					end
				end
				
				def getInnerHTML()
					html = ''
					@data.children() do |child|
						html += NokogiriAuxiliarToString.toString(child)
					end
					return html
				end
				
				def setInnerHTML(html)
					@data.inner_html = html
				end
				
				def getOuterHTML()
					return NokogiriAuxiliarToString.toString(@data)
				end
				
				def getData()
					return @data
				end
				
				def setData(data)
					@data = data
				end
				
				def cloneElement()
					return NokogiriHTMLDOMElement.new(@data.clone())
				end
				
				def getFirstElementChild()
					if not self.hasChildren?()
						return nil
					end
					return NokogiriHTMLDOMElement.new(@data.children()[0])
				end
				
				def getLastElementChild()
					if not self.hasChildren?()
						return nil
					end
					children = @data.children()
					return NokogiriHTMLDOMElement.new(children[children.length - 1])
				end
			end
		end
	end
end