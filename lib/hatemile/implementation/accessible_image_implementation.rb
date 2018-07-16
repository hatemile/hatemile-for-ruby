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

require File.join(File.dirname(File.dirname(__FILE__)), 'accessible_image')
require File.join(
  File.dirname(File.dirname(__FILE__)),
  'util',
  'common_functions'
)
require File.join(
  File.dirname(File.dirname(__FILE__)),
  'util',
  'id_generator'
)

##
# The Hatemile module contains the interfaces with the acessibility solutions.
module Hatemile
  ##
  # The Hatemile::Implementation module contains the official implementation of
  # interfaces solutions.
  module Implementation
    ##
    # The AccessibleImageImplementation class is official implementation of
    # AccessibleImage interface.
    class AccessibleImageImplementation < AccessibleImage
      public_class_method :new

      ##
      # The HTML class of element for show the long description of image.
      CLASS_LONG_DESCRIPTION_LINK = 'longdescription-link'.freeze

      ##
      # The name of attribute that link the anchor of long description with the
      # image.
      DATA_LONG_DESCRIPTION_FOR_IMAGE = 'data-longdescriptionfor'.freeze

      ##
      # Initializes a new object that manipulate the accessibility of the images
      # of parser.
      #
      # @param parser [Hatemile::Util::Html::HTMLDOMParser] The HTML parser.
      # @param configure [Hatemile::Util::Configure] The configuration of
      #   HaTeMiLe.
      def initialize(parser, configure)
        @parser = parser
        @id_generator = Hatemile::Util::IDGenerator.new('image')
        @prefix_long_description_link = configure.get_parameter(
          'prefix-longdescription'
        )
        @suffix_long_description_link = configure.get_parameter(
          'suffix-longdescription'
        )
      end

      ##
      # @see Hatemile::AccessibleImage#fix_long_description
      def fix_long_description(element)
        return unless element.has_attribute?('longdesc')

        @id_generator.generate_id(element)
        id = element.get_attribute('id')

        selector = "[#{DATA_LONG_DESCRIPTION_FOR_IMAGE}=\"#{id}\"]"
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
        anchor.set_attribute(DATA_LONG_DESCRIPTION_FOR_IMAGE, id)
        anchor.set_attribute('class', CLASS_LONG_DESCRIPTION_LINK)
        anchor.append_text(text)
        element.insert_after(anchor)
      end

      ##
      # @see Hatemile::AccessibleImage#fix_long_descriptions
      def fix_long_descriptions
        elements = @parser.find('[longdesc]').list_results
        elements.each do |element|
          if Hatemile::Util::CommonFunctions.is_valid_element?(element)
            fix_long_description(element)
          end
        end
      end
    end
  end
end
