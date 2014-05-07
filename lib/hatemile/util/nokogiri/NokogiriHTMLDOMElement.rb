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

module Hatemile
	module Util
		module NokogiriLib
			class NokogiriHTMLDOMElement < Hatemile::Util::HTMLDOMElement
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
					@data.remove_attribute(name)
				end
				def hasAttribute?(name)
					return @data.attributes[name] != nil
				end
				def hasAttributes?()
					return (not @data.attributes.empty?)
				end
				def getTextContent()
					return @data.text()
				end
				def insertBefore(newElement)
					@data.before(newElement.getData())
				end
				def insertAfter(newElement)
					@data.after(newElement.getData())
				end
				def removeElement()
					@data.remove()
				end
				def replaceElement(newElement)
					@data.replace(newElement.getData())
				end
				def appendElement(element)
					@data.add_child(element.getData())
				end
				def getChildren()
					array = Array.new
					@data.children() do |child|
						if child.element?
							array.push(NokogiriHTMLDOMElement.new(child))
						end
					end
					return array
				end
				def appendText(text)
					@data.add_child(Nokogiri::XML::Text.new(text, @data.document))
				end
				def hasChildren?()
					return @data.children().empty?
				end
				def getParentElement()
					if @data.parent() != nil and @data.parent().element?
						return NokogiriHTMLDOMElement.new(@data.parent())
					else
						return nil
					end
				end
				def getInnerHTML()
					return @data.inner_html
				end
				def setInnerHTML(html)
					@data.inner_html = html
				end
				def getOuterHTML()
					return @data.to_s()
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
					if @data.children().empty?
						return nil
					end
					return NokogiriHTMLDOMElement.new(@data.children()[0])
				end
				def getLastElementChild()
					if @data.children().empty?
						return nil
					end
					return NokogiriHTMLDOMElement.new(@data.children()[@data.children.length - 1])
				end
			end
		end
	end
end