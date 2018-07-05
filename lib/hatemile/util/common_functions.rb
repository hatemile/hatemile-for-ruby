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

module Hatemile
  module Util
    ##
    # The CommonFuncionts class contains the used methods by HaTeMiLe classes.
    class CommonFunctions
      private_class_method :new

      ##
      # Integer Count the number of ids created.
      @@count = 0

      ##
      # Generate a id for a element.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +element+ The element.
      #  2. String +prefix+ The prefix of id.
      def self.generateId(element, prefix)
        unless element.hasAttribute?('id')
          element.setAttribute('id', prefix + @@count.to_s)
          @@count += 1
        end
      end

      ##
      # Reset the count number of ids.
      def self.resetCount
        @@count = 0
      end

      ##
      # Copy a list of attributes of a element for other element.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +element1+ The element that have attributes copied.
      #  2. Hatemile::Util::HTMLDOMElement +element2+ The element that copy the attributes.
      #  3. Array(String) +attributes+ The list of attributes that will be copied.
      def self.setListAttributes(element1, element2, attributes)
        attributes.each do |attribute|
          if element1.hasAttribute?(attribute)
            element2.setAttribute(attribute, element1.getAttribute(attribute))
          end
        end
      end

      ##
      # Increase a item in a list.
      #
      # ---
      #
      # Parameters:
      #  1. String +list+ The list.
      #  2. String +stringToIncrease+ The value of item.
      # Return:
      # String True if the list contains the item or false is not contains.
      def self.increaseInList(list, stringToIncrease)
        if (list != nil) and (!list.empty?) and (stringToIncrease != nil) and (!stringToIncrease.empty?)
          if self.inList(list, stringToIncrease)
            return list
          else
            return "#{list} #{stringToIncrease}"
          end
        elsif (list != nil) and (!list.empty?)
          return list
        else
          return stringToIncrease
        end
      end

      ##
      # Verify if the list contains the item.
      #
      # ---
      #
      # Parameters:
      #  1. String +list+ The list.
      #  2. String +stringToSearch+ The value of item.
      # Return:
      # Boolean True if the list contains the item or false is not contains.
      def self.inList(list, stringToSearch)
        if (list != nil) and (!list.empty?) and (stringToSearch != nil) and (!stringToSearch.empty?)
          elements = list.split(/[ \n\t\r]+/)
          elements.each do |element|
            if element == stringToSearch
              return true
            end
          end
        end
        return false
      end
    end
  end
end
