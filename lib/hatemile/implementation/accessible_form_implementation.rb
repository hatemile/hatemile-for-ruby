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
      def addPrefixSuffix(label, field, prefix, suffix, dataPrefix, dataSuffix)
        content = field.getAttribute('aria-label')
        unless prefix.empty?
          label.setAttribute(dataPrefix, prefix)
          content = "#{prefix} #{content}" unless content.include?(prefix)
        end
        unless suffix.empty?
          label.setAttribute(dataSuffix, suffix)
          content = "#{content} #{suffix}" unless content.include?(suffix)
        end
        field.setAttribute('aria-label', content)
      end

      ##
      # Display in label the information if the field is required.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +label+ The label.
      #  2. Hatemile::Util::HTMLDOMElement +requiredField+ The required field.
      def fixLabelRequiredField(label, requiredField)
        if (requiredField.hasAttribute?('required') || (requiredField.hasAttribute?('aria-required') \
            && (requiredField.getAttribute('aria-required').downcase == 'true'))) \
            && requiredField.hasAttribute?('aria-label') \
            && !label.hasAttribute?(@dataLabelPrefixRequiredField) \
            && !label.hasAttribute?(@dataLabelSuffixRequiredField)
          addPrefixSuffix(label, requiredField, @prefixRequiredField, @suffixRequiredField \
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
      def fixLabelRangeField(label, rangeField)
        if rangeField.hasAttribute?('aria-label')
          if (rangeField.hasAttribute?('min') || rangeField.hasAttribute?('aria-valuemin')) \
              && !label.hasAttribute?(@dataLabelPrefixRangeMinField) \
              && !label.hasAttribute?(@dataLabelSuffixRangeMinField)
            value = if rangeField.hasAttribute?('min')
                      rangeField.getAttribute('min')
                    else
                      rangeField.getAttribute('aria-valuemin')
                    end
            addPrefixSuffix(label, rangeField, @prefixRangeMinField.gsub(/{{value}}/, value) \
                , @suffixRangeMinField.gsub(/{{value}}/, value) \
                , @dataLabelPrefixRangeMinField, @dataLabelSuffixRangeMinField)
          end
          if (rangeField.hasAttribute?('max') || rangeField.hasAttribute?('aria-valuemax')) \
              && !label.hasAttribute?(@dataLabelPrefixRangeMaxField) \
              && !label.hasAttribute?(@dataLabelSuffixRangeMaxField)
            value = if rangeField.hasAttribute?('max')
                      rangeField.getAttribute('max')
                    else
                      rangeField.getAttribute('aria-valuemax')
                    end
            addPrefixSuffix(label, rangeField, @prefixRangeMaxField.gsub(/{{value}}/, value) \
                , @suffixRangeMaxField.gsub(/{{value}}/, value) \
                , @dataLabelPrefixRangeMaxField, @dataLabelSuffixRangeMaxField)
          end
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
      def fixLabelAutoCompleteField(label, autoCompleteField)
        prefixAutoCompleteFieldModified = ''
        suffixAutoCompleteFieldModified = ''
        if autoCompleteField.hasAttribute?('aria-label') \
            && !label.hasAttribute?(@dataLabelPrefixAutoCompleteField) \
            && !label.hasAttribute?(@dataLabelSuffixAutoCompleteField)
          ariaAutocomplete = getARIAAutoComplete(autoCompleteField)
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
            addPrefixSuffix(label, autoCompleteField, prefixAutoCompleteFieldModified \
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
      def getARIAAutoComplete(field)
        tagName = field.getTagName
        type = nil
        if field.hasAttribute?('type')
          type = field.getAttribute('type').downcase
        end
        if (tagName == 'TEXTAREA') || ((tagName == 'INPUT') && !((type == 'button') || (type == 'submit') || (type == 'reset') || (type == 'image') || (type == 'file') || (type == 'checkbox') || (type == 'radio') || (type == 'hidden')))
          value = nil
          if field.hasAttribute?('autocomplete')
            value = field.getAttribute('autocomplete').downcase
          else
            form = @parser.find(field).findAncestors('form').firstResult
            if form.nil? && field.hasAttribute?('form')
              form = @parser.find("##{field.getAttribute('form')}").firstResult
            end
            if !form.nil? && form.hasAttribute?('autocomplete')
              value = form.getAttribute('autocomplete').downcase
            end
          end
          if value == 'on'
            return 'both'
          elsif field.hasAttribute?('list') && !@parser.find("datalist[id=\"#{field.getAttribute('list')}\"]").firstResult.nil?
            return 'list'
          elsif value == 'off'
            return 'none'
          end
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
      def getLabels(field)
        labels = nil
        if field.hasAttribute?('id')
          labels = @parser.find("label[for=\"#{field.getAttribute('id')}\"]").listResults
        end
        if labels.nil? || labels.empty?
          labels = @parser.find(field).findAncestors('label').listResults
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
        @prefixId = configure.getParameter('prefix-generated-ids')
        @prefixRequiredField = configure.getParameter('prefix-required-field')
        @suffixRequiredField = configure.getParameter('suffix-required-field')
        @prefixRangeMinField = configure.getParameter('prefix-range-min-field')
        @suffixRangeMinField = configure.getParameter('suffix-range-min-field')
        @prefixRangeMaxField = configure.getParameter('prefix-range-max-field')
        @suffixRangeMaxField = configure.getParameter('suffix-range-max-field')
        @prefixAutoCompleteField = configure.getParameter('prefix-autocomplete-field')
        @suffixAutoCompleteField = configure.getParameter('suffix-autocomplete-field')
        @textAutoCompleteValueBoth = configure.getParameter('text-autocomplete-value-both')
        @textAutoCompleteValueList = configure.getParameter('text-autocomplete-value-list')
        @textAutoCompleteValueInline = configure.getParameter('text-autocomplete-value-inline')
        @textAutoCompleteValueNone = configure.getParameter('text-autocomplete-value-none')
      end

      def fixRequiredField(requiredField)
        if requiredField.hasAttribute?('required')
          requiredField.setAttribute('aria-required', 'true')

          labels = getLabels(requiredField)
          labels.each do |label|
            fixLabelRequiredField(label, requiredField)
          end
        end
      end

      def fixRequiredFields
        requiredFields = @parser.find('[required]').listResults
        requiredFields.each do |requiredField|
          unless requiredField.hasAttribute?(@dataIgnore)
            fixRequiredField(requiredField)
          end
        end
      end

      def fixRangeField(rangeField)
        if rangeField.hasAttribute?('min')
          rangeField.setAttribute('aria-valuemin', rangeField.getAttribute('min'))
        end
        if rangeField.hasAttribute?('max')
          rangeField.setAttribute('aria-valuemax', rangeField.getAttribute('max'))
        end
        labels = getLabels(rangeField)
        labels.each do |label|
          fixLabelRequiredField(label, rangeField)
        end
      end

      def fixRangeFields
        rangeFields = @parser.find('[min],[max]').listResults
        rangeFields.each do |rangeField|
          fixRangeField(rangeField) unless rangeField.hasAttribute?(@dataIgnore)
        end
      end

      def fixAutoCompleteField(autoCompleteField)
        ariaAutoComplete = getARIAAutoComplete(autoCompleteField)
        unless ariaAutoComplete.nil?
          autoCompleteField.setAttribute('aria-autocomplete', ariaAutoComplete)

          labels = getLabels(autoCompleteField)
          labels.each do |label|
            fixLabelAutoCompleteField(label, autoCompleteField)
          end
        end
      end

      def fixAutoCompleteFields
        elements = @parser.find('input[autocomplete],textarea[autocomplete],form[autocomplete] input,form[autocomplete] textarea,[list],[form]').listResults
        elements.each do |element|
          unless element.hasAttribute?(@dataIgnore)
            fixAutoCompleteField(element)
          end
        end
      end

      def fixLabel(label)
        if label.getTagName == 'LABEL'
          if label.hasAttribute?('for')
            field = @parser.find("##{label.getAttribute('for')}").firstResult
          else
            field = @parser.find(label).findDescendants('input,select,textarea').firstResult

            unless field.nil?
              Hatemile::Util::CommonFunctions.generateId(field, @prefixId)
              label.setAttribute('for', field.getAttribute('id'))
            end
          end
          unless field.nil?
            unless field.hasAttribute?('aria-label')
              field.setAttribute('aria-label', label.getTextContent.gsub(/[ \n\r\t]+/, ' '))
            end

            fixLabelRequiredField(label, field)
            fixLabelRangeField(label, field)
            fixLabelAutoCompleteField(label, field)

            Hatemile::Util::CommonFunctions.generateId(label, @prefixId)
            field.setAttribute('aria-labelledby', Hatemile::Util::CommonFunctions
                .increaseInList(field.getAttribute('aria-labelledby'), label.getAttribute('id')))
          end
        end
      end

      def fixLabels
        labels = @parser.find('label').listResults
        labels.each do |label|
          fixLabel(label) unless label.hasAttribute?(@dataIgnore)
        end
      end
    end
  end
end
