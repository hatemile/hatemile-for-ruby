# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'nokogiri'
require File.dirname(__FILE__) + '/../html_dom_parser.rb'
require File.dirname(__FILE__) + '/nokogiri_html_dom_element.rb'

module Hatemile
  module Util
    module NokogiriLib
      ##
      # The class NokogiriHTMLDOMParser is official implementation of HTMLDOMParser
      # interface for the Nokogiri library.
      class NokogiriHTMLDOMParser < Hatemile::Util::HTMLDOMParser
        public_class_method :new

        protected

        ##
        # Order the results.
        #
        # ---
        #
        # Parameters:
        #  1. Array(Nokogiri::XML::Node) +results+ The disordened results.
        # Return:
        # Array(Nokogiri::XML::Node) The ordened results.
        def orderResults(results)
          parents = []
          groups = []
          results.each do |result|
            unless parents.include?(result.parent)
              parents.push(result.parent)
              groups.push([])
              groups[groups.size - 1].push(result)
            else
              groups[parents.index(result.parent)].push(result)
            end
          end
          array = []
          groups.each do |group|
            col = group.sort { |element1, element2|
              children = element1.parent.children
              children.index(element1) <=> children.index(element2)
            }
            array = array.concat(col)
          end
          return array
        end

        public

        ##
        # Initializes a new object that encapsulate the parser of Jsoup.
        #
        # ---
        #
        # Parameters:
        #  1. String|Nokogiri::HTML::Document +codeOrParser+
        #   * String The HTML code.
        #   * Nokogiri::HTML::Document The parser of Nokogiri.
        #  2. String +encoding+ The enconding of code.
        def initialize(codeOrParser, encoding = 'UTF-8')
          if codeOrParser.class == String
            @document = Nokogiri::HTML::Document.parse(codeOrParser, nil, encoding)
          else
            @document = codeOrParser
          end
          @results = nil
        end

        def find(selector)
          if selector.class == NokogiriHTMLDOMElement
            @results = [selector.getData]
          else
            @results = @document.css(selector)
          end
          return self
        end

        def findChildren(selector)
          array = []
          if selector.class == NokogiriHTMLDOMElement
            element = selector.getData
            @results.each do |result|
              if result.children.include?(element)
                array.push(element)
                break
              end
            end
          else
            @results.each do |result|
              result.css(selector).each do |element|
                if element.parent == result
                  array.push(element)
                end
              end
            end
          end
          @results = array
          return self
        end

        def findDescendants(selector)
          array = []
          if selector.class == NokogiriHTMLDOMElement
            element = selector.getData
            parents = element.ancestors
            @results.each do |result|
              if parents.include?(result)
                array.push(element)
                break
              end
            end
          else
            @results.each do |result|
              array = array.concat(result.css(selector))
            end
          end
          @results = array
          return self
        end

        def findAncestors(selector)
          array = []
          if selector.class == NokogiriHTMLDOMElement
            element = selector.getData
            @results.each do |result|
              parents = result.ancestors
              if parents.include?(element)
                array.push(element)
                break
              end
            end
          else
            @results.each do |result|
              array = array.concat(result.ancestors(selector))
            end
          end
          @results = array
          return self
        end

        def firstResult
          if (@results == nil) or (@results.empty?)
            return nil
          end
          return NokogiriHTMLDOMElement.new(@results[0])
        end

        def lastResult
          if (@results == nil) or (@results.empty?)
            return nil
          end
          return NokogiriHTMLDOMElement.new(@results[@results.length - 1])
        end

        def listResults
          array = []
          self.orderResults(@results).each do |result|
            array.push(NokogiriHTMLDOMElement.new(result))
          end
          return array
        end

        def createElement(tag)
          return NokogiriHTMLDOMElement.new(@document.create_element(tag))
        end

        def getHTML
          return NokogiriHTMLDOMElement.new(@document).getOuterHTML
        end

        def getParser
          return @document
        end

        def clearParser
          @document = nil
          @results.clear
          @results = nil
        end
      end
    end
  end
end
