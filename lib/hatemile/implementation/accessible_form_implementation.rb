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
require File.join(File.dirname(__FILE__), 'accessible_event_implementation')
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

      ##
      # The ID of script element that contains the list of IDs of fields with
      # validation.
      ID_SCRIPT_LIST_VALIDATION_FIELDS =
        'hatemile-scriptlist-validation-fields'.freeze

      ##
      # The ID of script element that execute validations on fields.
      ID_SCRIPT_EXECUTE_VALIDATION = 'hatemile-validation-script'.freeze

      ##
      # The client-site required fields list.
      REQUIRED_FIELDS_LIST = 'required_fields'.freeze

      ##
      # The client-site pattern fields list.
      PATTERN_FIELDS_LIST = 'pattern_fields'.freeze

      ##
      # The client-site fields with length list.
      LIMITED_FIELDS_LIST = 'fields_with_length'.freeze

      ##
      # The client-site range fields list.
      RANGE_FIELDS_LIST = 'range_fields'.freeze

      ##
      # The client-site week fields list.
      WEEK_FIELDS_LIST = 'week_fields'.freeze

      ##
      # The client-site month fields list.
      MONTH_FIELDS_LIST = 'month_fields'.freeze

      ##
      # The client-site datetime fields list.
      DATETIME_FIELDS_LIST = 'datetime_fields'.freeze

      ##
      # The client-site time fields list.
      TIME_FIELDS_LIST = 'time_fields'.freeze

      ##
      # The client-site date fields list.
      DATE_FIELDS_LIST = 'date_fields'.freeze

      ##
      # The client-site email fields list.
      EMAIL_FIELDS_LIST = 'email_fields'.freeze

      ##
      # The client-site URL fields list.
      URL_FIELDS_LIST = 'url_fields'.freeze

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
          if field.has_attribute?('list')
            list_id = field.get_attribute('list')
            unless @parser.find("datalist[id=\"#{list_id}\"]").first_result.nil?
              return 'list'
            end
          end
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
        end
        nil
      end

      ##
      # Include the scripts used by solutions.
      def generate_validation_scripts
        local = @parser.find('head,body').first_result
        unless local.nil?
          if @parser.find(
            "##{AccessibleEventImplementation::ID_SCRIPT_COMMON_FUNCTIONS}"
          ).first_result.nil?
            common_functions_script = @parser.create_element('script')
            common_functions_script.set_attribute(
              'id',
              AccessibleEventImplementation::ID_SCRIPT_COMMON_FUNCTIONS
            )
            common_functions_script.set_attribute('type', 'text/javascript')
            common_functions_script.append_text(
              File.read(
                File.join(
                  File.dirname(File.dirname(File.dirname(__FILE__))),
                  'js',
                  'common.js'
                )
              )
            )
            local.prepend_element(common_functions_script)
          end
        end
        @script_list_fields_with_validation = @parser.find(
          "##{ID_SCRIPT_LIST_VALIDATION_FIELDS}"
        ).first_result
        if @script_list_fields_with_validation.nil?
          @script_list_fields_with_validation = @parser.create_element('script')
          @script_list_fields_with_validation.set_attribute(
            'id',
            ID_SCRIPT_LIST_VALIDATION_FIELDS
          )
          @script_list_fields_with_validation.set_attribute(
            'type',
            'text/javascript'
          )
          @script_list_fields_with_validation.append_text(
            File.read(
              File.join(
                File.dirname(File.dirname(File.dirname(__FILE__))),
                'js',
                'scriptlist_validation_fields.js'
              )
            )
          )
          local.append_element(@script_list_fields_with_validation)
        end
        if @parser.find("##{ID_SCRIPT_EXECUTE_VALIDATION}").first_result.nil?
          script_function = @parser.create_element('script')
          script_function.set_attribute('id', ID_SCRIPT_EXECUTE_VALIDATION)
          script_function.set_attribute('type', 'text/javascript')
          script_function.append_text(
            File.read(
              File.join(
                File.dirname(File.dirname(File.dirname(__FILE__))),
                'js',
                'validation.js'
              )
            )
          )
          @parser.find('body').first_result.append_element(script_function)
        end
        @scripts_added = true
      end

      ##
      # Validate the field when its value change.
      #
      # @param field [Hatemile::Util::Html::HTMLDOMElement] The field.
      # @param list_attribute [String] The list attribute of field with
      #   validation.
      def validate(field, list_attribute)
        generate_validation_scripts unless @scripts_added
        @id_generator.generate_id(field)
        @script_list_fields_with_validation.append_text(
          "hatemileValidationList.#{list_attribute}.push(" \
          "'#{field.get_attribute('id')}');"
        )
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
        @scripts_added = false
        @script_list_fields_with_validation = nil
      end

      ##
      # @see Hatemile::AccessibleForm#mark_required_field
      def mark_required_field(required_field)
        return unless required_field.has_attribute?('required')

        required_field.set_attribute('aria-required', 'true')
      end

      ##
      # @see Hatemile::AccessibleForm#mark_all_required_fields
      def mark_all_required_fields
        required_fields = @parser.find('[required]').list_results
        required_fields.each do |required_field|
          if Hatemile::Util::CommonFunctions.is_valid_element?(required_field)
            mark_required_field(required_field)
          end
        end
      end

      ##
      # @see Hatemile::AccessibleForm#mark_range_field
      def mark_range_field(range_field)
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
      # @see Hatemile::AccessibleForm#mark_all_range_fields
      def mark_all_range_fields
        range_fields = @parser.find('[min],[max]').list_results
        range_fields.each do |range_field|
          if Hatemile::Util::CommonFunctions.is_valid_element?(range_field)
            mark_range_field(range_field)
          end
        end
      end

      ##
      # @see Hatemile::AccessibleForm#mark_autocomplete_field
      def mark_autocomplete_field(autocomplete_field)
        aria_autocomplete = get_aria_autocomplete(autocomplete_field)

        return if aria_autocomplete.nil?

        autocomplete_field.set_attribute('aria-autocomplete', aria_autocomplete)
      end

      ##
      # @see Hatemile::AccessibleForm#mark_all_autocomplete_fields
      def mark_all_autocomplete_fields
        elements = @parser.find(
          'input[autocomplete],textarea[autocomplete],form[autocomplete] ' \
          'input,form[autocomplete] textarea,[list],[form]'
        ).list_results
        elements.each do |element|
          if Hatemile::Util::CommonFunctions.is_valid_element?(element)
            mark_autocomplete_field(element)
          end
        end
      end

      ##
      # @see Hatemile::AccessibleForm#mark_invalid_field
      def mark_invalid_field(field)
        if field.has_attribute?('required') ||
           (
             field.has_attribute?('aria-required') &&
             field.get_attribute('aria-required').casecmp('true').zero?
           )
          validate(field, REQUIRED_FIELDS_LIST)
        end
        validate(field, PATTERN_FIELDS_LIST) if field.has_attribute?('pattern')
        if field.has_attribute?('minlength') ||
           field.has_attribute?('maxlength')
          validate(field, LIMITED_FIELDS_LIST)
        end
        if field.has_attribute?('aria-valuemin') ||
           field.has_attribute?('aria-valuemax')
          validate(field, RANGE_FIELDS_LIST)
        end

        return unless field.has_attribute?('type')

        type_field = field.get_attribute('type').downcase
        if type_field == 'week'
          validate(field, WEEK_FIELDS_LIST)
        elsif type_field == 'month'
          validate(field, MONTH_FIELDS_LIST)
        elsif %w[datetime-local datetime].include?(type_field)
          validate(field, DATETIME_FIELDS_LIST)
        elsif type_field == 'time'
          validate(field, TIME_FIELDS_LIST)
        elsif type_field == 'date'
          validate(field, DATE_FIELDS_LIST)
        elsif %w[number range].include?(type_field)
          validate(field, RANGE_FIELDS_LIST)
        elsif type_field == 'email'
          validate(field, EMAIL_FIELDS_LIST)
        elsif type_field == 'url'
          validate(field, AccessibleFormImplementation.URL_FIELDS_LIST)
        end
      end

      ##
      # @see Hatemile::AccessibleForm#mark_all_invalid_fields
      def mark_all_invalid_fields
        fields = @parser.find(
          '[required],input[pattern],input[minlength],input[maxlength],' \
          'textarea[minlength],textarea[maxlength],input[type=week],' \
          'input[type=month],input[type=datetime-local],' \
          'input[type=datetime],input[type=time],input[type=date],' \
          'input[type=number],input[type=range],input[type=email],' \
          'input[type=url],[aria-required=true],input[aria-valuemin],' \
          'input[aria-valuemax]'
        ).list_results
        fields.each do |field|
          if Hatemile::Util::CommonFunctions.is_valid_element?(field)
            mark_invalid_field(field)
          end
        end
      end
    end
  end
end
