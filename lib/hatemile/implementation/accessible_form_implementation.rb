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
          unless content.include?(prefix)
            content = "#{prefix} #{content}"
          end
        end
        unless suffix.empty?
          label.setAttribute(dataSuffix, suffix)
          unless content.include?(suffix)
            content = "#{content} #{suffix}"
          end
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
        if ((requiredField.hasAttribute?('required')) or ((requiredField.hasAttribute?('aria-required')) \
            and (requiredField.getAttribute('aria-required').downcase == 'true'))) \
            and (requiredField.hasAttribute?('aria-label')) \
            and (!label.hasAttribute?(@dataLabelPrefixRequiredField)) \
            and (!label.hasAttribute?(@dataLabelSuffixRequiredField))
          self.addPrefixSuffix(label, requiredField, @prefixRequiredField, @suffixRequiredField \
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
          if (rangeField.hasAttribute?('min') or rangeField.hasAttribute?('aria-valuemin')) \
              and (!label.hasAttribute?(@dataLabelPrefixRangeMinField)) \
              and (!label.hasAttribute?(@dataLabelSuffixRangeMinField))
            if rangeField.hasAttribute?('min')
              value = rangeField.getAttribute('min')
            else
              value = rangeField.getAttribute('aria-valuemin')
            end
            self.addPrefixSuffix(label, rangeField, @prefixRangeMinField.gsub(/{{value}}/, value) \
                , @suffixRangeMinField.gsub(/{{value}}/, value) \
                , @dataLabelPrefixRangeMinField, @dataLabelSuffixRangeMinField)
          end
          if (rangeField.hasAttribute?('max') or rangeField.hasAttribute?('aria-valuemax')) \
              and (!label.hasAttribute?(@dataLabelPrefixRangeMaxField)) \
              and (!label.hasAttribute?(@dataLabelSuffixRangeMaxField))
            if rangeField.hasAttribute?('max')
              value = rangeField.getAttribute('max')
            else
              value = rangeField.getAttribute('aria-valuemax')
            end
            self.addPrefixSuffix(label, rangeField, @prefixRangeMaxField.gsub(/{{value}}/, value) \
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
        if (autoCompleteField.hasAttribute?('aria-label')) \
            and (!label.hasAttribute?(@dataLabelPrefixAutoCompleteField)) \
            and (!label.hasAttribute?(@dataLabelSuffixAutoCompleteField))
          ariaAutocomplete = self.getARIAAutoComplete(autoCompleteField)
          if ariaAutocomplete != nil
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
            self.addPrefixSuffix(label, autoCompleteField, prefixAutoCompleteFieldModified \
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
        if (tagName == 'TEXTAREA') or ((tagName == 'INPUT') and (!(('button' == type) or ('submit' == type) or ('reset' == type) or ('image' == type) or ('file' == type) or ('checkbox' == type) or ('radio' == type) or ('hidden' == type))))
          value = nil
          if field.hasAttribute?('autocomplete')
            value = field.getAttribute('autocomplete').downcase
          else
            form = @parser.find(field).findAncestors('form').firstResult
            if (form == nil) and (field.hasAttribute?('form'))
              form = @parser.find("##{field.getAttribute('form')}").firstResult
            end
            if (form != nil) and (form.hasAttribute?('autocomplete'))
              value = form.getAttribute('autocomplete').downcase
            end
          end
          if 'on' == value
            return 'both'
          elsif (field.hasAttribute?('list')) and (@parser.find("datalist[id=\"#{field.getAttribute('list')}\"]").firstResult != nil)
            return 'list'
          elsif 'off' == value
            return 'none'
          end
        end
        return nil
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
        if (labels == nil) or (labels.empty?)
          labels = @parser.find(field).findAncestors('label').listResults
        end
        return labels
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

          labels = self.getLabels(requiredField)
          labels.each do |label|
            self.fixLabelRequiredField(label, requiredField)
          end
        end
      end

      def fixRequiredFields
        requiredFields = @parser.find('[required]').listResults
        requiredFields.each do |requiredField|
          unless requiredField.hasAttribute?(@dataIgnore)
            self.fixRequiredField(requiredField)
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
        labels = self.getLabels(rangeField)
        labels.each do |label|
          self.fixLabelRequiredField(label, rangeField)
        end
      end

      def fixRangeFields
        rangeFields = @parser.find('[min],[max]').listResults
        rangeFields.each do |rangeField|
          unless rangeField.hasAttribute?(@dataIgnore)
            self.fixRangeField(rangeField)
          end
        end
      end

      def fixAutoCompleteField(autoCompleteField)
        ariaAutoComplete = self.getARIAAutoComplete(autoCompleteField)
        if ariaAutoComplete != nil
          autoCompleteField.setAttribute('aria-autocomplete', ariaAutoComplete)

          labels = self.getLabels(autoCompleteField);
          labels.each do |label|
            self.fixLabelAutoCompleteField(label, autoCompleteField)
          end
        end
      end

      def fixAutoCompleteFields
        elements = @parser.find('input[autocomplete],textarea[autocomplete],form[autocomplete] input,form[autocomplete] textarea,[list],[form]').listResults
        elements.each do |element|
          unless element.hasAttribute?(@dataIgnore)
            self.fixAutoCompleteField(element)
          end
        end
      end

      def fixLabel(label)
        if label.getTagName == 'LABEL'
          if label.hasAttribute?('for')
            field = @parser.find("##{label.getAttribute('for')}").firstResult
          else
            field = @parser.find(label).findDescendants('input,select,textarea').firstResult

            if field != nil
              Hatemile::Util::CommonFunctions.generateId(field, @prefixId)
              label.setAttribute('for', field.getAttribute('id'))
            end
          end
          if field != nil
            unless field.hasAttribute?('aria-label')
              field.setAttribute('aria-label', label.getTextContent.gsub(/[ \n\r\t]+/, ' '))
            end

            self.fixLabelRequiredField(label, field)
            self.fixLabelRangeField(label, field)
            self.fixLabelAutoCompleteField(label, field)

            Hatemile::Util::CommonFunctions.generateId(label, @prefixId)
            field.setAttribute('aria-labelledby', Hatemile::Util::CommonFunctions
                .increaseInList(field.getAttribute('aria-labelledby'), label.getAttribute('id')))
          end
        end
      end

      def fixLabels
        labels = @parser.find('label').listResults
        labels.each do |label|
          unless label.hasAttribute?(@dataIgnore)
            self.fixLabel(label)
          end
        end
      end
    end
  end
end
