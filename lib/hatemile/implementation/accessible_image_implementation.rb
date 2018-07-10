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

require File.dirname(__FILE__) + '/../accessible_image.rb'
require File.dirname(__FILE__) + '/../util/common_functions.rb'

module Hatemile
  module Implementation
    ##
    # The AccessibleImageImplementation class is official implementation of
    # AccessibleImage interface.
    class AccessibleImageImplementation < AccessibleImage
      public_class_method :new

      ##
      # Initializes a new object that manipulate the accessibility of the images
      # of parser.
      #
      # @param parser [Hatemile::Util::HTMLDOMParser] The HTML parser.
      # @param configure [Hatemile::Util::Configure] The configuration of
      #   HaTeMiLe.
      def initialize(parser, configure)
        @parser = parser
        @prefix_id = configure.get_parameter('prefix-generated-ids')
        @class_long_description_link = 'longdescription-link'
        @data_long_description_for_image = 'data-longdescriptionfor'
        @data_ignore = 'data-ignoreaccessibilityfix'
        @prefix_long_description_link = configure.get_parameter(
          'prefix-longdescription'
        )
        @suffix_long_description_link = configure.get_parameter(
          'suffix-longdescription'
        )
      end

      def fix_long_description(element)
        return unless element.has_attribute?('longdesc')

        Hatemile::Util::CommonFunctions.generate_id(element, @prefix_id)
        id = element.get_attribute('id')

        selector = "[#{@data_long_description_for_image}=\"#{id}\"]"
        return unless @parser.find(selector).first_result.nil?

        text = if element.has_attribute?('alt')
                 "#{@prefix_long_description_link} " \
                 "#{element.get_attribute('alt')} " \
                 "#{@suffix_long_description_link}"
               else
                 "#{@prefix_long_description_link} " \
                 "#{@suffix_long_description_link}"
               end
        anchor = @parser.create_element('a')
        anchor.set_attribute('href', element.get_attribute('longdesc'))
        anchor.set_attribute('target', '_blank')
        anchor.set_attribute(@data_long_description_for_image, id)
        anchor.set_attribute('class', @class_long_description_link)
        anchor.append_text(text)
        element.insert_after(anchor)
      end

      def fix_long_descriptions
        elements = @parser.find('[longdesc]').list_results
        elements.each do |element|
          unless element.has_attribute?(@data_ignore)
            fix_long_description(element)
          end
        end
      end
    end
  end
end
