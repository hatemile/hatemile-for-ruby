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
        @prefixId = configure.getParameter('prefix-generated-ids')
        @classLongDescriptionLink = 'longdescription-link'
        @dataLongDescriptionForImage = 'data-longdescriptionfor'
        @dataIgnore = 'data-ignoreaccessibilityfix'
        @prefixLongDescriptionLink = configure.getParameter('prefix-longdescription')
        @suffixLongDescriptionLink = configure.getParameter('suffix-longdescription')
      end

      def fixLongDescription(element)
        if element.hasAttribute?('longdesc')
          Hatemile::Util::CommonFunctions.generateId(element, @prefixId)
          id = element.getAttribute('id')
          if @parser.find("[#{@dataLongDescriptionForImage}=\"#{id}\"]").firstResult.nil?
            if element.hasAttribute?('alt')
              text = "#{@prefixLongDescriptionLink} #{element.getAttribute('alt')} #{@suffixLongDescriptionLink}"
            else
              text = "#{@prefixLongDescriptionLink} #{@suffixLongDescriptionLink}"
            end
            anchor = @parser.createElement('a')
            anchor.setAttribute('href', element.getAttribute('longdesc'))
            anchor.setAttribute('target', '_blank')
            anchor.setAttribute(@dataLongDescriptionForImage, id)
            anchor.setAttribute('class', @classLongDescriptionLink)
            anchor.appendText(text)
            element.insertAfter(anchor)
          end
        end
      end

      def fixLongDescriptions
        elements = @parser.find('[longdesc]').listResults
        elements.each do |element|
          unless element.hasAttribute?(@dataIgnore)
            self.fixLongDescription(element)
          end
        end
      end
    end
  end
end
