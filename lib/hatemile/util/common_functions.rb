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
      # @param element [Hatemile::Util::HTMLDOMElement] The element.
      # @param prefix [String] The prefix of id.
      # @return [void]
      def self.generate_id(element, prefix)
        return if element.has_attribute?('id')

        element.set_attribute('id', prefix + @@count.to_s)
        @@count += 1
      end

      ##
      # Reset the count number of ids.
      #
      # @return [void]
      def self.reset_count
        @@count = 0
      end

      ##
      # Copy a list of attributes of a element for other element.
      #
      # @param element1 [Hatemile::Util::HTMLDOMElement] The element that have
      #   attributes copied.
      # @param element2 [Hatemile::Util::HTMLDOMElement] The element that copy
      #   the attributes.
      # @param attributes [Array<String>] The list of attributes that will be
      #   copied.
      # @return [void]
      def self.set_list_attributes(element1, element2, attributes)
        attributes.each do |attribute|
          if element1.has_attribute?(attribute)
            element2.set_attribute(attribute, element1.get_attribute(attribute))
          end
        end
      end

      ##
      # Increase a item in a list.
      #
      # @param list [String] The list.
      # @param string_to_increase [String] The value of item.
      # @return [String] True if the list contains the item or false is not
      #   contains.
      def self.increase_in_list(list, string_to_increase)
        if !list.nil? && !list.empty? && !string_to_increase.nil? && !string_to_increase.empty?
          return list if in_list(list, string_to_increase)
          return "#{list} #{string_to_increase}"
        elsif !list.nil? && !list.empty?
          return list
        end
        string_to_increase
      end

      ##
      # Verify if the list contains the item.
      #
      # @param list [String] The list.
      # @param string_to_search [String] The value of item.
      # @return [Boolean] True if the list contains the item or false is not
      #   contains.
      def self.in_list(list, string_to_search)
        if !list.nil? && !list.empty? && !string_to_search.nil? && !string_to_search.empty?
          elements = list.split(/[ \n\t\r]+/)
          elements.each do |element|
            return true if element == string_to_search
          end
        end
        false
      end
    end
  end
end
