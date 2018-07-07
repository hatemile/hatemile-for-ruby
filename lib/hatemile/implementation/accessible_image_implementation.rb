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
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMParser +parser+ The HTML parser.
      #  2. Hatemile::Util::Configure +configure+ The configuration of HaTeMiLe.
      def initialize(parser, configure)
        @parser = parser
        @prefixId = configure.get_parameter('prefix-generated-ids')
        @classLongDescriptionLink = 'longdescription-link'
        @dataLongDescriptionForImage = 'data-longdescriptionfor'
        @dataIgnore = 'data-ignoreaccessibilityfix'
        @prefixLongDescriptionLink = configure.get_parameter('prefix-longdescription')
        @suffixLongDescriptionLink = configure.get_parameter('suffix-longdescription')
      end

      def fix_long_description(element)
        return unless element.has_attribute?('longdesc')

        Hatemile::Util::CommonFunctions.generate_id(element, @prefixId)
        id = element.get_attribute('id')

        return unless @parser.find("[#{@dataLongDescriptionForImage}=\"#{id}\"]").first_result.nil?

        if element.has_attribute?('alt')
          text = "#{@prefixLongDescriptionLink} #{element.get_attribute('alt')} #{@suffixLongDescriptionLink}"
        else
          text = "#{@prefixLongDescriptionLink} #{@suffixLongDescriptionLink}"
        end
        anchor = @parser.create_element('a')
        anchor.set_attribute('href', element.get_attribute('longdesc'))
        anchor.set_attribute('target', '_blank')
        anchor.set_attribute(@dataLongDescriptionForImage, id)
        anchor.set_attribute('class', @classLongDescriptionLink)
        anchor.append_text(text)
        element.insert_after(anchor)
      end

      def fix_long_descriptions
        elements = @parser.find('[longdesc]').list_results
        elements.each do |element|
          fix_long_description(element) unless element.has_attribute?(@dataIgnore)
        end
      end
    end
  end
end
