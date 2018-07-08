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

require File.dirname(__FILE__) + '/../accessible_form.rb'
require File.dirname(__FILE__) + '/../util/common_functions.rb'

module Hatemile
  module Implementation
    ##
    # The AccessibleFormImplementation class is official implementation of
    # AccessibleForm interface.
    class AccessibleFormImplementation < AccessibleForm
      public_class_method :new

      protected

      ##
      # Display in label the information of field.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +label+ The label.
      #  2. Hatemile::Util::HTMLDOMElement +field+ The field.
      #  3. String +prefix+ The prefix.
      #  4. String +suffix+ The suffix.
      #  5. String +data_prefix+ The name of prefix attribute.
      #  6. String +data_suffix+ The name of suffix attribute.
      def add_prefix_suffix(label, field, prefix, suffix, data_prefix, data_suffix)
        content = field.get_attribute('aria-label')
        unless prefix.empty?
          label.set_attribute(data_prefix, prefix)
          content = "#{prefix} #{content}" unless content.include?(prefix)
        end
        unless suffix.empty?
          label.set_attribute(data_suffix, suffix)
          content = "#{content} #{suffix}" unless content.include?(suffix)
        end
        field.set_attribute('aria-label', content)
      end

      ##
      # Display in label the information if the field is required.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +label+ The label.
      #  2. Hatemile::Util::HTMLDOMElement +required_field+ The required field.
      def fix_label_required_field(label, required_field)
        if (required_field.has_attribute?('required') || (required_field.has_attribute?('aria-required') \
            && required_field.get_attribute('aria-required').casecmp('true').zero?)) \
            && required_field.has_attribute?('aria-label') \
            && !label.has_attribute?(@data_label_prefix_required_field) \
            && !label.has_attribute?(@data_label_suffix_required_field)
          add_prefix_suffix(label, required_field, @prefix_required_field, @suffix_required_field \
              , @data_label_prefix_required_field, @data_label_suffix_required_field)
        end
      end

      ##
      # Display in label the information of range of field.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +label+ The label.
      #  2. Hatemile::Util::HTMLDOMElement +range_field+ The range field.
      def fix_label_range_field(label, range_field)
        return unless range_field.has_attribute?('aria-label')

        if (range_field.has_attribute?('min') || range_field.has_attribute?('aria-valuemin')) \
            && !label.has_attribute?(@data_label_prefix_range_min_field) \
            && !label.has_attribute?(@data_label_suffix_range_min_field)
          value = if range_field.has_attribute?('min')
                    range_field.get_attribute('min')
                  else
                    range_field.get_attribute('aria-valuemin')
                  end
          add_prefix_suffix(label, range_field, @prefix_range_min_field.gsub(/{{value}}/, value) \
              , @suffix_range_min_field.gsub(/{{value}}/, value) \
              , @data_label_prefix_range_min_field, @data_label_suffix_range_min_field)
        end
        if (range_field.has_attribute?('max') || range_field.has_attribute?('aria-valuemax')) \
            && !label.has_attribute?(@data_label_prefix_range_max_field) \
            && !label.has_attribute?(@data_label_suffix_range_max_field)
          value = if range_field.has_attribute?('max')
                    range_field.get_attribute('max')
                  else
                    range_field.get_attribute('aria-valuemax')
                  end
          add_prefix_suffix(label, range_field, @prefix_range_max_field.gsub(/{{value}}/, value) \
              , @suffix_range_max_field.gsub(/{{value}}/, value) \
              , @data_label_prefix_range_max_field, @data_label_suffix_range_max_field)
        end
      end

      ##
      # Display in label the information if the field has autocomplete.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +label+ The label.
      #  2. Hatemile::Util::HTMLDOMElement +autocomplete_field+ The autocomplete field.
      def fix_label_autocomplete_field(label, autocomplete_field)
        prefix_autocomplete_field_modified = ''
        suffix_autocomplete_field_modified = ''
        if autocomplete_field.has_attribute?('aria-label') \
            && !label.has_attribute?(@data_label_prefix_autocomplete_field) \
            && !label.has_attribute?(@data_label_suffix_autocomplete_field)
          aria_autocomplete = get_aria_autocomplete(autocomplete_field)
          unless aria_autocomplete.nil?
            if aria_autocomplete == 'both'
              unless @prefix_autocomplete_field.empty?
                prefix_autocomplete_field_modified = @prefix_autocomplete_field.gsub(/{{value}}/, @text_autocomplete_value_both)
              end
              unless @suffix_autocomplete_field.empty?
                suffix_autocomplete_field_modified = @suffix_autocomplete_field.gsub(/{{value}}/, @text_autocomplete_value_both)
              end
            elsif aria_autocomplete == 'none'
              unless @prefix_autocomplete_field.empty?
                prefix_autocomplete_field_modified = @prefix_autocomplete_field.gsub(/{{value}}/, @text_autocomplete_value_none)
              end
              unless @suffix_autocomplete_field.empty?
                suffix_autocomplete_field_modified = @suffix_autocomplete_field.gsub(/{{value}}/, @text_autocomplete_value_none)
              end
            elsif aria_autocomplete == 'list'
              unless @prefix_autocomplete_field.empty?
                prefix_autocomplete_field_modified = @prefix_autocomplete_field.gsub(/{{value}}/, @text_autocomplete_value_list)
              end
              unless @suffix_autocomplete_field.empty?
                suffix_autocomplete_field_modified = @suffix_autocomplete_field.gsub(/{{value}}/, @text_autocomplete_value_list)
              end
            end
            add_prefix_suffix(label, autocomplete_field, prefix_autocomplete_field_modified \
                , suffix_autocomplete_field_modified, @data_label_prefix_autocomplete_field \
                , @data_label_suffix_autocomplete_field)
          end
        end
      end

      ##
      # Returns the appropriate value for attribute aria-autocomplete of field.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +field+ The field.
      # Return:
      # String The ARIA value of field.
      def get_aria_autocomplete(field)
        tag_name = field.get_tag_name
        type = nil
        if field.has_attribute?('type')
          type = field.get_attribute('type').downcase
        end
        if (tag_name == 'TEXTAREA') || ((tag_name == 'INPUT') && !((type == 'button') || (type == 'submit') || (type == 'reset') || (type == 'image') || (type == 'file') || (type == 'checkbox') || (type == 'radio') || (type == 'hidden')))
          value = nil
          if field.has_attribute?('autocomplete')
            value = field.get_attribute('autocomplete').downcase
          else
            form = @parser.find(field).find_ancestors('form').first_result
            if form.nil? && field.has_attribute?('form')
              form = @parser.find("##{field.get_attribute('form')}").first_result
            end
            if !form.nil? && form.has_attribute?('autocomplete')
              value = form.get_attribute('autocomplete').downcase
            end
          end
          return 'both' if value == 'on'
          return 'none' if value == 'off'
          return 'list' if field.has_attribute?('list') && !@parser.find("datalist[id=\"#{field.get_attribute('list')}\"]").first_result.nil?
        end
        nil
      end

      ##
      # Returns the labels of field.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +field+ The field.
      # Return:
      # Array(Hatemile::Util::HTMLDOMElement) The labels of field.
      def get_labels(field)
        labels = nil
        if field.has_attribute?('id')
          labels = @parser.find("label[for=\"#{field.get_attribute('id')}\"]").list_results
        end
        if labels.nil? || labels.empty?
          labels = @parser.find(field).find_ancestors('label').list_results
        end
        labels
      end

      public

      ##
      # Initializes a new object that manipulate the accessibility of the forms
      # of parser.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMParser +parser+ The HTML parser.
      #  2. Hatemile::Util::Configure +configure+ The configuration of HaTeMiLe.
      def initialize(parser, configure)
        @parser = parser
        @data_label_prefix_required_field = 'data-prefixrequiredfield'
        @data_label_suffix_required_field = 'data-suffixrequiredfield'
        @data_label_prefix_range_min_field = 'data-prefixvalueminfield'
        @data_label_suffix_range_min_field = 'data-suffixvalueminfield'
        @data_label_prefix_range_max_field = 'data-prefixvaluemaxfield'
        @data_label_suffix_range_max_field = 'data-suffixvaluemaxfield'
        @data_label_prefix_autocomplete_field = 'data-prefixautocompletefield'
        @data_label_suffix_autocomplete_field = 'data-suffixautocompletefield'
        @data_ignore = 'data-ignoreaccessibilityfix'
        @prefix_id = configure.get_parameter('prefix-generated-ids')
        @prefix_required_field = configure.get_parameter('prefix-required-field')
        @suffix_required_field = configure.get_parameter('suffix-required-field')
        @prefix_range_min_field = configure.get_parameter('prefix-range-min-field')
        @suffix_range_min_field = configure.get_parameter('suffix-range-min-field')
        @prefix_range_max_field = configure.get_parameter('prefix-range-max-field')
        @suffix_range_max_field = configure.get_parameter('suffix-range-max-field')
        @prefix_autocomplete_field = configure.get_parameter('prefix-autocomplete-field')
        @suffix_autocomplete_field = configure.get_parameter('suffix-autocomplete-field')
        @text_autocomplete_value_both = configure.get_parameter('text-autocomplete-value-both')
        @text_autocomplete_value_list = configure.get_parameter('text-autocomplete-value-list')
        @text_autocomplete_value_inline = configure.get_parameter('text-autocomplete-value-inline')
        @text_autocomplete_value_none = configure.get_parameter('text-autocomplete-value-none')
      end

      def fix_required_field(required_field)
        return unless required_field.has_attribute?('required')

        required_field.set_attribute('aria-required', 'true')

        labels = get_labels(required_field)
        labels.each do |label|
          fix_label_required_field(label, required_field)
        end
      end

      def fix_required_fields
        required_fields = @parser.find('[required]').list_results
        required_fields.each do |required_field|
          unless required_field.has_attribute?(@data_ignore)
            fix_required_field(required_field)
          end
        end
      end

      def fix_range_field(range_field)
        if range_field.has_attribute?('min')
          range_field.set_attribute('aria-valuemin', range_field.get_attribute('min'))
        end
        if range_field.has_attribute?('max')
          range_field.set_attribute('aria-valuemax', range_field.get_attribute('max'))
        end
        labels = get_labels(range_field)
        labels.each do |label|
          fix_label_required_field(label, range_field)
        end
      end

      def fix_range_fields
        range_fields = @parser.find('[min],[max]').list_results
        range_fields.each do |range_field|
          fix_range_field(range_field) unless range_field.has_attribute?(@data_ignore)
        end
      end

      def fix_autocomplete_field(autocomplete_field)
        aria_autocomplete = get_aria_autocomplete(autocomplete_field)

        return if aria_autocomplete.nil?

        autocomplete_field.set_attribute('aria-autocomplete', aria_autocomplete)

        labels = get_labels(autocomplete_field)
        labels.each do |label|
          fix_label_autocomplete_field(label, autocomplete_field)
        end
      end

      def fix_autocomplete_fields
        elements = @parser.find('input[autocomplete],textarea[autocomplete],form[autocomplete] input,form[autocomplete] textarea,[list],[form]').list_results
        elements.each do |element|
          unless element.has_attribute?(@data_ignore)
            fix_autocomplete_field(element)
          end
        end
      end

      def fix_label(label)
        return unless label.get_tag_name == 'LABEL'

        if label.has_attribute?('for')
          field = @parser.find("##{label.get_attribute('for')}").first_result
        else
          field = @parser.find(label).find_descendants('input,select,textarea').first_result

          unless field.nil?
            Hatemile::Util::CommonFunctions.generate_id(field, @prefix_id)
            label.set_attribute('for', field.get_attribute('id'))
          end
        end

        return if field.nil?

        unless field.has_attribute?('aria-label')
          field.set_attribute('aria-label', label.get_text_content.gsub(/[ \n\r\t]+/, ' '))
        end

        fix_label_required_field(label, field)
        fix_label_range_field(label, field)
        fix_label_autocomplete_field(label, field)

        Hatemile::Util::CommonFunctions.generate_id(label, @prefix_id)
        field.set_attribute('aria-labelledby', Hatemile::Util::CommonFunctions
            .increase_in_list(field.get_attribute('aria-labelledby'), label.get_attribute('id')))
      end

      def fix_labels
        labels = @parser.find('label').list_results
        labels.each do |label|
          fix_label(label) unless label.has_attribute?(@data_ignore)
        end
      end
    end
  end
end
