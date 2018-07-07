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
      #  5. String +dataPrefix+ The name of prefix attribute.
      #  6. String +dataSuffix+ The name of suffix attribute.
      def add_prefix_suffix(label, field, prefix, suffix, dataPrefix, dataSuffix)
        content = field.get_attribute('aria-label')
        unless prefix.empty?
          label.set_attribute(dataPrefix, prefix)
          content = "#{prefix} #{content}" unless content.include?(prefix)
        end
        unless suffix.empty?
          label.set_attribute(dataSuffix, suffix)
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
      #  2. Hatemile::Util::HTMLDOMElement +requiredField+ The required field.
      def fix_label_required_field(label, requiredField)
        if (requiredField.has_attribute?('required') || (requiredField.has_attribute?('aria-required') \
            && requiredField.get_attribute('aria-required').casecmp('true').zero?)) \
            && requiredField.has_attribute?('aria-label') \
            && !label.has_attribute?(@dataLabelPrefixRequiredField) \
            && !label.has_attribute?(@dataLabelSuffixRequiredField)
          add_prefix_suffix(label, requiredField, @prefixRequiredField, @suffixRequiredField \
              , @dataLabelPrefixRequiredField, @dataLabelSuffixRequiredField)
        end
      end

      ##
      # Display in label the information of range of field.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +label+ The label.
      #  2. Hatemile::Util::HTMLDOMElement +rangeField+ The range field.
      def fix_label_range_field(label, rangeField)
        return unless rangeField.has_attribute?('aria-label')

        if (rangeField.has_attribute?('min') || rangeField.has_attribute?('aria-valuemin')) \
            && !label.has_attribute?(@dataLabelPrefixRangeMinField) \
            && !label.has_attribute?(@dataLabelSuffixRangeMinField)
          value = if rangeField.has_attribute?('min')
                    rangeField.get_attribute('min')
                  else
                    rangeField.get_attribute('aria-valuemin')
                  end
          add_prefix_suffix(label, rangeField, @prefixRangeMinField.gsub(/{{value}}/, value) \
              , @suffixRangeMinField.gsub(/{{value}}/, value) \
              , @dataLabelPrefixRangeMinField, @dataLabelSuffixRangeMinField)
        end
        if (rangeField.has_attribute?('max') || rangeField.has_attribute?('aria-valuemax')) \
            && !label.has_attribute?(@dataLabelPrefixRangeMaxField) \
            && !label.has_attribute?(@dataLabelSuffixRangeMaxField)
          value = if rangeField.has_attribute?('max')
                    rangeField.get_attribute('max')
                  else
                    rangeField.get_attribute('aria-valuemax')
                  end
          add_prefix_suffix(label, rangeField, @prefixRangeMaxField.gsub(/{{value}}/, value) \
              , @suffixRangeMaxField.gsub(/{{value}}/, value) \
              , @dataLabelPrefixRangeMaxField, @dataLabelSuffixRangeMaxField)
        end
      end

      ##
      # Display in label the information if the field has autocomplete.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +label+ The label.
      #  2. Hatemile::Util::HTMLDOMElement +autoCompleteField+ The autocomplete field.
      def fix_label_autocomplete_field(label, autoCompleteField)
        prefixAutoCompleteFieldModified = ''
        suffixAutoCompleteFieldModified = ''
        if autoCompleteField.has_attribute?('aria-label') \
            && !label.has_attribute?(@dataLabelPrefixAutoCompleteField) \
            && !label.has_attribute?(@dataLabelSuffixAutoCompleteField)
          ariaAutocomplete = get_aria_autocomplete(autoCompleteField)
          unless ariaAutocomplete.nil?
            if ariaAutocomplete == 'both'
              unless @prefixAutoCompleteField.empty?
                prefixAutoCompleteFieldModified = @prefixAutoCompleteField.gsub(/{{value}}/, @textAutoCompleteValueBoth)
              end
              unless @suffixAutoCompleteField.empty?
                suffixAutoCompleteFieldModified = @suffixAutoCompleteField.gsub(/{{value}}/, @textAutoCompleteValueBoth)
              end
            elsif ariaAutocomplete == 'none'
              unless @prefixAutoCompleteField.empty?
                prefixAutoCompleteFieldModified = @prefixAutoCompleteField.gsub(/{{value}}/, @textAutoCompleteValueNone)
              end
              unless @suffixAutoCompleteField.empty?
                suffixAutoCompleteFieldModified = @suffixAutoCompleteField.gsub(/{{value}}/, @textAutoCompleteValueNone)
              end
            elsif ariaAutocomplete == 'list'
              unless @prefixAutoCompleteField.empty?
                prefixAutoCompleteFieldModified = @prefixAutoCompleteField.gsub(/{{value}}/, @textAutoCompleteValueList)
              end
              unless @suffixAutoCompleteField.empty?
                suffixAutoCompleteFieldModified = @suffixAutoCompleteField.gsub(/{{value}}/, @textAutoCompleteValueList)
              end
            end
            add_prefix_suffix(label, autoCompleteField, prefixAutoCompleteFieldModified \
                , suffixAutoCompleteFieldModified, @dataLabelPrefixAutoCompleteField \
                , @dataLabelSuffixAutoCompleteField)
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
        tagName = field.get_tag_name
        type = nil
        if field.has_attribute?('type')
          type = field.get_attribute('type').downcase
        end
        if (tagName == 'TEXTAREA') || ((tagName == 'INPUT') && !((type == 'button') || (type == 'submit') || (type == 'reset') || (type == 'image') || (type == 'file') || (type == 'checkbox') || (type == 'radio') || (type == 'hidden')))
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
        @dataLabelPrefixRequiredField = 'data-prefixrequiredfield'
        @dataLabelSuffixRequiredField = 'data-suffixrequiredfield'
        @dataLabelPrefixRangeMinField = 'data-prefixvalueminfield'
        @dataLabelSuffixRangeMinField = 'data-suffixvalueminfield'
        @dataLabelPrefixRangeMaxField = 'data-prefixvaluemaxfield'
        @dataLabelSuffixRangeMaxField = 'data-suffixvaluemaxfield'
        @dataLabelPrefixAutoCompleteField = 'data-prefixautocompletefield'
        @dataLabelSuffixAutoCompleteField = 'data-suffixautocompletefield'
        @dataIgnore = 'data-ignoreaccessibilityfix'
        @prefixId = configure.get_parameter('prefix-generated-ids')
        @prefixRequiredField = configure.get_parameter('prefix-required-field')
        @suffixRequiredField = configure.get_parameter('suffix-required-field')
        @prefixRangeMinField = configure.get_parameter('prefix-range-min-field')
        @suffixRangeMinField = configure.get_parameter('suffix-range-min-field')
        @prefixRangeMaxField = configure.get_parameter('prefix-range-max-field')
        @suffixRangeMaxField = configure.get_parameter('suffix-range-max-field')
        @prefixAutoCompleteField = configure.get_parameter('prefix-autocomplete-field')
        @suffixAutoCompleteField = configure.get_parameter('suffix-autocomplete-field')
        @textAutoCompleteValueBoth = configure.get_parameter('text-autocomplete-value-both')
        @textAutoCompleteValueList = configure.get_parameter('text-autocomplete-value-list')
        @textAutoCompleteValueInline = configure.get_parameter('text-autocomplete-value-inline')
        @textAutoCompleteValueNone = configure.get_parameter('text-autocomplete-value-none')
      end

      def fix_required_field(requiredField)
        return unless requiredField.has_attribute?('required')

        requiredField.set_attribute('aria-required', 'true')

        labels = get_labels(requiredField)
        labels.each do |label|
          fix_label_required_field(label, requiredField)
        end
      end

      def fix_required_fields
        requiredFields = @parser.find('[required]').list_results
        requiredFields.each do |requiredField|
          unless requiredField.has_attribute?(@dataIgnore)
            fix_required_field(requiredField)
          end
        end
      end

      def fix_range_field(rangeField)
        if rangeField.has_attribute?('min')
          rangeField.set_attribute('aria-valuemin', rangeField.get_attribute('min'))
        end
        if rangeField.has_attribute?('max')
          rangeField.set_attribute('aria-valuemax', rangeField.get_attribute('max'))
        end
        labels = get_labels(rangeField)
        labels.each do |label|
          fix_label_required_field(label, rangeField)
        end
      end

      def fix_range_fields
        rangeFields = @parser.find('[min],[max]').list_results
        rangeFields.each do |rangeField|
          fix_range_field(rangeField) unless rangeField.has_attribute?(@dataIgnore)
        end
      end

      def fix_autocomplete_field(autoCompleteField)
        ariaAutoComplete = get_aria_autocomplete(autoCompleteField)

        return if ariaAutoComplete.nil?

        autoCompleteField.set_attribute('aria-autocomplete', ariaAutoComplete)

        labels = get_labels(autoCompleteField)
        labels.each do |label|
          fix_label_autocomplete_field(label, autoCompleteField)
        end
      end

      def fix_autocomplete_fields
        elements = @parser.find('input[autocomplete],textarea[autocomplete],form[autocomplete] input,form[autocomplete] textarea,[list],[form]').list_results
        elements.each do |element|
          unless element.has_attribute?(@dataIgnore)
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
            Hatemile::Util::CommonFunctions.generate_id(field, @prefixId)
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

        Hatemile::Util::CommonFunctions.generate_id(label, @prefixId)
        field.set_attribute('aria-labelledby', Hatemile::Util::CommonFunctions
            .increase_in_list(field.get_attribute('aria-labelledby'), label.get_attribute('id')))
      end

      def fix_labels
        labels = @parser.find('label').list_results
        labels.each do |label|
          fix_label(label) unless label.has_attribute?(@dataIgnore)
        end
      end
    end
  end
end
