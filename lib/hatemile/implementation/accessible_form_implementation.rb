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

require File.join(File.dirname(File.dirname(__FILE__)), 'accessible_form')
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
    # The AccessibleFormImplementation class is official implementation of
    # AccessibleForm interface.
    class AccessibleFormImplementation < AccessibleForm
      public_class_method :new

      protected

      ##
      # Returns the appropriate value for attribute aria-autocomplete of field.
      #
      # @param field [Hatemile::Util::Html::HTMLDOMElement] The field.
      # @return [String] The ARIA value of field.
      def get_aria_autocomplete(field)
        tag_name = field.get_tag_name
        type = nil
        if field.has_attribute?('type')
          type = field.get_attribute('type').downcase
        end
        if (tag_name == 'TEXTAREA') ||
           (
             (tag_name == 'INPUT') &&
             !(
               (type == 'button') ||
               (type == 'submit') ||
               (type == 'reset') ||
               (type == 'image') ||
               (type == 'file') ||
               (type == 'checkbox') ||
               (type == 'radio') ||
               (type == 'hidden')
             )
           )
          value = nil
          if field.has_attribute?('autocomplete')
            value = field.get_attribute('autocomplete').downcase
          else
            form = @parser.find(field).find_ancestors('form').first_result
            if form.nil? && field.has_attribute?('form')
              form = @parser.find(
                "##{field.get_attribute('form')}"
              ).first_result
            end
            if !form.nil? && form.has_attribute?('autocomplete')
              value = form.get_attribute('autocomplete').downcase
            end
          end
          return 'both' if value == 'on'
          return 'none' if value == 'off'
          if field.has_attribute?('list')
            list_id = field.get_attribute('list')
            unless @parser.find("datalist[id=\"#{list_id}\"]").first_result.nil?
              return 'list'
            end
          end
        end
        nil
      end

      public

      ##
      # Initializes a new object that manipulate the accessibility of the forms
      # of parser.
      #
      # @param parser [Hatemile::Util::Html::HTMLDOMParser] The HTML parser.
      def initialize(parser)
        @parser = parser
        @id_generator = Hatemile::Util::IDGenerator.new('form')
      end

      ##
      # @see Hatemile::AccessibleForm#fix_required_field
      def fix_required_field(required_field)
        return unless required_field.has_attribute?('required')

        required_field.set_attribute('aria-required', 'true')
      end

      ##
      # @see Hatemile::AccessibleForm#fix_required_fields
      def fix_required_fields
        required_fields = @parser.find('[required]').list_results
        required_fields.each do |required_field|
          if Hatemile::Util::CommonFunctions.is_valid_element?(required_field)
            fix_required_field(required_field)
          end
        end
      end

      ##
      # @see Hatemile::AccessibleForm#fix_range_field
      def fix_range_field(range_field)
        if range_field.has_attribute?('min')
          range_field.set_attribute(
            'aria-valuemin',
            range_field.get_attribute('min')
          )
        end

        return unless range_field.has_attribute?('max')

        range_field.set_attribute(
          'aria-valuemax',
          range_field.get_attribute('max')
        )
      end

      ##
      # @see Hatemile::AccessibleForm#fix_range_fields
      def fix_range_fields
        range_fields = @parser.find('[min],[max]').list_results
        range_fields.each do |range_field|
          if Hatemile::Util::CommonFunctions.is_valid_element?(range_field)
            fix_range_field(range_field)
          end
        end
      end

      ##
      # @see Hatemile::AccessibleForm#fix_autocomplete_field
      def fix_autocomplete_field(autocomplete_field)
        aria_autocomplete = get_aria_autocomplete(autocomplete_field)

        return if aria_autocomplete.nil?

        autocomplete_field.set_attribute('aria-autocomplete', aria_autocomplete)
      end

      ##
      # @see Hatemile::AccessibleForm#fix_autocomplete_fields
      def fix_autocomplete_fields
        elements = @parser.find(
          'input[autocomplete],textarea[autocomplete],form[autocomplete] ' \
          'input,form[autocomplete] textarea,[list],[form]'
        ).list_results
        elements.each do |element|
          if Hatemile::Util::CommonFunctions.is_valid_element?(element)
            fix_autocomplete_field(element)
          end
        end
      end
    end
  end
end
