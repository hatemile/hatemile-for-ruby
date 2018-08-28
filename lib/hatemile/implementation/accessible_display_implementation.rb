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

require 'rexml/document'
require File.join(File.dirname(File.dirname(__FILE__)), 'accessible_display')
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
    # The AccessibleDisplayImplementation class is official implementation of
    # Hatemile::AccessibleDisplay for screen readers.
    class AccessibleDisplayImplementation < AccessibleDisplay
      public_class_method :new

      ##
      # The id of list element that contains the description of shortcuts,
      # before the whole content of page.
      ID_CONTAINER_SHORTCUTS_BEFORE = 'container-shortcuts-before'.freeze

      ##
      # The id of list element that contains the description of shortcuts, after
      # the whole content of page.
      ID_CONTAINER_SHORTCUTS_AFTER = 'container-shortcuts-after'.freeze

      ##
      # The HTML class of text of description of container of shortcuts
      # descriptions.
      CLASS_TEXT_SHORTCUTS = 'text-shortcuts'.freeze

      ##
      # The HTML class of content to force the screen reader show the current
      # state of element, before it.
      CLASS_FORCE_READ_BEFORE = 'force-read-before'.freeze

      ##
      # The HTML class of content to force the screen reader show the current
      # state of element, after it.
      CLASS_FORCE_READ_AFTER = 'force-read-after'.freeze

      ##
      # The name of attribute that links the content of autocomplete state of
      # field.
      DATA_ARIA_AUTOCOMPLETE_OF = 'data-ariaautocompleteof'.freeze

      ##
      # The name of attribute that links the content of busy state of element.
      DATA_ARIA_BUSY_OF = 'data-ariabusyof'.freeze

      ##
      # The name of attribute that links the content of checked state field.
      DATA_ARIA_CHECKED_OF = 'data-ariacheckedof'.freeze

      ##
      # The name of attribute that links the content of drop effect state of
      # element.
      DATA_ARIA_DROPEFFECT_OF = 'data-ariadropeffectof'.freeze

      ##
      # The name of attribute that links the content of expanded state of
      # element.
      DATA_ARIA_EXPANDED_OF = 'data-ariaexpandedof'.freeze

      ##
      # The name of attribute that links the content of grabbed state of
      # element.
      DATA_ARIA_GRABBED_OF = 'data-ariagrabbedof'.freeze

      ##
      # The name of attribute that links the content that show if the field has
      # popup.
      DATA_ARIA_HASPOPUP_OF = 'data-ariahaspopupof'.freeze

      ##
      # The name of attribute that links the content of level state of element.
      DATA_ARIA_LEVEL_OF = 'data-arialevelof'.freeze

      ##
      # The name of attribute that links the content of orientation state of
      # element.
      DATA_ARIA_ORIENTATION_OF = 'data-ariaorientationof'.freeze

      ##
      # The name of attribute that links the content of pressed state of field.
      DATA_ARIA_PRESSED_OF = 'data-ariapressedof'.freeze

      ##
      # The name of attribute that links the content of minimum range state of
      # field.
      DATA_ARIA_RANGE_MIN_OF = 'data-attributevalueminof'.freeze

      ##
      # The name of attribute that links the content of maximum range state of
      # field.
      DATA_ARIA_RANGE_MAX_OF = 'data-attributevaluemaxof'.freeze

      ##
      # The name of attribute that links the content of required state of field.
      DATA_ARIA_REQUIRED_OF = 'data-attributerequiredof'.freeze

      ##
      # The name of attribute that links the content of selected state of field.
      DATA_ARIA_SELECTED_OF = 'data-ariaselectedof'.freeze

      ##
      # The name of attribute that links the content of sort state of element.
      DATA_ARIA_SORT_OF = 'data-ariasortof'.freeze

      ##
      # The name of attribute that links the description of shortcut of element.
      DATA_ATTRIBUTE_ACCESSKEY_OF = 'data-attributeaccesskeyof'.freeze

      ##
      # The name of attribute that links the content of download link.
      DATA_ATTRIBUTE_DOWNLOAD_OF = 'data-attributedownloadof'.freeze

      ##
      # The name of attribute that links the content of header cell with the
      # data cell.
      DATA_ATTRIBUTE_HEADERS_OF = 'data-headersof'.freeze

      ##
      # The name of attribute that links the content of link that open a new
      # instance.
      DATA_ATTRIBUTE_TARGET_OF = 'data-attributetargetof'.freeze

      ##
      # The name of attribute that links the content of role of element with the
      # element.
      DATA_ROLE_OF = 'data-roleof'.freeze

      protected

      ##
      # Returns the description of element.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element with
      #   description.
      # @return [String] The description of element.
      def get_description(element)
        description = nil
        tag_name = element.get_tag_name
        if element.has_attribute?('title')
          description = element.get_attribute('title')
        elsif element.has_attribute?('aria-label')
          description = element.get_attribute('aria-label')
        elsif element.has_attribute?('alt')
          description = element.get_attribute('alt')
        elsif element.has_attribute?('label')
          description = element.get_attribute('label')
        elsif element.has_attribute?('aria-labelledby') ||
              element.has_attribute?('aria-describedby')
          description_ids = if element.has_attribute?('aria-labelledby')
                              element.get_attribute(
                                'aria-labelledby'
                              ).split(/[ \n\t\r]+/)
                            else
                              element.get_attribute(
                                'aria-describedby'
                              ).split(/[ \n\t\r]+/)
                            end
          description_ids.each do |description_id|
            element_description = @parser.find(
              "##{description_id}"
            ).first_result
            unless element_description.nil?
              description = element_description.get_text_content
              break
            end
          end
        elsif %w[INPUT TEXTAREA OPTION].include?(tag_name)
          if element.has_attribute?('type') &&
             %w[button submit reset].include?(
               element.get_attribute('type').downcase
             ) &&
             element.has_attribute?('value')
            description = element.get_attribute('value')
          else
            label = nil
            if element.has_attribute?('id')
              field_id = element.get_attribute('id')
              label = @parser.find("label[for=\"#{field_id}\"]").first_result
            end
            if label.nil?
              label = @parser.find(element).find_ancestors('label').first_result
            end
            description = label.get_text_content unless label.nil?
          end
        end
        description = element.get_text_content if description.nil?
        description.gsub(/[ \n\t\r]+/, ' ').strip
      end

      ##
      # Generate the list of shortcuts of page.
      #
      # @return [void]
      def generate_list_shortcuts
        local = @parser.find('body').first_result

        return if local.nil?

        container_before = @parser.find(
          "##{ID_CONTAINER_SHORTCUTS_BEFORE}"
        ).first_result
        if container_before.nil? && !@attribute_accesskey_before.empty?
          container_before = @parser.create_element('div')
          container_before.set_attribute('id', ID_CONTAINER_SHORTCUTS_BEFORE)

          text_container_before = @parser.create_element('span')
          text_container_before.set_attribute('class', CLASS_TEXT_SHORTCUTS)
          text_container_before.append_text(@attribute_accesskey_before)

          container_before.append_element(text_container_before)
          local.prepend_element(container_before)
        end
        unless container_before.nil?
          @list_shortcuts_before = @parser.find(
            container_before
          ).find_children('ul').first_result
          if @list_shortcuts_before.nil?
            @list_shortcuts_before = @parser.create_element('ul')
            container_before.append_element(@list_shortcuts_before)
          end
        end
        container_after = @parser.find(
          "##{ID_CONTAINER_SHORTCUTS_AFTER}"
        ).first_result
        if container_after.nil? && !@attribute_accesskey_after.empty?
          container_after = @parser.create_element('div')
          container_after.set_attribute('id', ID_CONTAINER_SHORTCUTS_AFTER)

          text_container_after = @parser.create_element('span')
          text_container_after.set_attribute('class', CLASS_TEXT_SHORTCUTS)
          text_container_after.append_text(@attribute_accesskey_after)

          container_after.append_element(text_container_after)
          local.append_element(container_after)
        end
        unless container_after.nil?
          @list_shortcuts_after = @parser.find(
            container_after
          ).find_children('ul').first_result
          if @list_shortcuts_after.nil?
            @list_shortcuts_after = @parser.create_element('ul')
            container_after.append_element(@list_shortcuts_after)
          end
        end
        @list_shortcuts_added = true
      end

      ##
      # Returns the shortcut prefix of browser.
      #
      # @param user_agent [String] The user agent of browser.
      # @param standart_prefix [String] The default prefix.
      # @return [String] The shortcut prefix of browser.
      def get_shortcut_prefix(user_agent, standart_prefix)
        return standart_prefix if user_agent.nil?

        user_agent = user_agent.downcase
        opera = user_agent.include?('opera')
        mac = user_agent.include?('mac')
        konqueror = user_agent.include?('konqueror')
        spoofer = user_agent.include?('spoofer')
        safari = user_agent.include?('applewebkit')
        windows = user_agent.include?('windows')
        chrome = user_agent.include?('chrome')
        firefox = user_agent.include?('firefox') ||
                  user_agent.include?('minefield')
        ie = user_agent.include?('msie') || user_agent.include?('trident')

        return 'SHIFT + ESC' if opera
        return 'CTRL + OPTION' if chrome && mac && !spoofer
        return 'CTRL + ALT' if safari && !windows && !spoofer
        return 'CTRL' if !windows && (safari || mac || konqueror)
        return 'ALT + SHIFT' if firefox
        return 'ALT' if chrome || ie

        standart_prefix
      end

      ##
      # Returns the description of role.
      #
      # @param role [String] The role.
      # @return [String] The description of role.
      def get_role_description(role)
        parameter = "role-#{role.downcase}"
        if @configure.has_parameter?(parameter)
          return @configure.get_parameter(parameter)
        end
        nil
      end

      ##
      # Insert a element before or after other element.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The reference
      #   element.
      # @param new_element [Hatemile::Util::Html::HTMLDOMElement] The element
      #   that be inserted.
      # @param before [Boolean] To insert the element before the other element.
      # @return [void]
      def insert(element, new_element, before)
        tag_name = element.get_tag_name
        append_tags = %w[BODY A FIGCAPTION LI DT DD LABEL OPTION TD TH]
        controls = %w[INPUT SELECT TEXTAREA]
        if tag_name == 'HTML'
          body = @parser.find('body').first_result
          insert(body, new_element, before) unless body.nil?
        elsif append_tags.include?(tag_name)
          element.prepend_element(new_element) if before
          element.append_element(new_element) unless before
        elsif controls.include?(tag_name)
          labels = []
          if element.has_attribute?('id')
            labels = @parser.find(
              "label[for=\"#{element.get_attribute('id')}\"]"
            ).list_results
          end
          if labels.empty?
            labels = @parser.find(element).find_ancestors('label').list_results
          end
          labels.each do |label|
            insert(label, new_element, before)
          end
        elsif before
          element.insert_before(new_element)
        else
          element.insert_after(new_element)
        end
      end

      ##
      # Force the screen reader display an information of element.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The reference
      #   element.
      # @param text_before [String] The text content to show before the element.
      # @param text_after [String] The text content to show after the element.
      # @param data_of [String] The name of attribute that links the content with
      #   element.
      # @return [void]
      def force_read_simple(element, text_before, text_after, data_of)
        @id_generator.generate_id(element)
        identifier = element.get_attribute('id')
        selector = "[#{data_of}=\"#{identifier}\"]"

        reference_before = @parser.find(
          ".#{CLASS_FORCE_READ_BEFORE}#{selector}"
        ).first_result
        reference_after = @parser.find(
          ".#{CLASS_FORCE_READ_AFTER}#{selector}"
        ).first_result
        references = @parser.find(selector).list_results
        if references.include?(reference_before)
          references.delete(reference_before)
        end
        if references.include?(reference_after)
          references.delete(reference_after)
        end

        return unless references.empty?

        unless text_before.empty?
          reference_before.remove_node unless reference_before.nil?

          span = @parser.create_element('span')
          span.set_attribute('class', CLASS_FORCE_READ_BEFORE)
          span.set_attribute(data_of, identifier)
          span.append_text(text_before)
          insert(element, span, true)
        end

        return if text_after.empty?

        reference_after.remove_node unless reference_after.nil?

        span = @parser.create_element('span')
        span.set_attribute('class', CLASS_FORCE_READ_AFTER)
        span.set_attribute(data_of, identifier)
        span.append_text(text_after)
        insert(element, span, false)
      end

      ##
      # Force the screen reader display an information of element with prefixes
      # or suffixes.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The reference
      #   element.
      # @param value [String] The value to be show.
      # @param text_prefix_before [String] The prefix of value to show before
      #   the element.
      # @param text_suffix_before [String] The suffix of value to show before
      #   the element.
      # @param text_prefix_after [String] The prefix of value to show after the
      #   element.
      # @param text_suffix_after [String] The suffix of value to show after the
      #   element.
      # @param data_of [String] The name of attribute that links the content
      #   with element.
      # @return [void]
      def force_read(
        element,
        value,
        text_prefix_before,
        text_suffix_before,
        text_prefix_after,
        text_suffix_after,
        data_of
      )
        text_before = if !text_prefix_before.empty? ||
                         !text_suffix_before.empty?
                        text_prefix_before + value + text_suffix_before
                      else
                        ''
                      end
        text_after = if !text_prefix_after.empty? || !text_suffix_after.empty?
                       text_prefix_after + value + text_suffix_after
                     else
                       ''
                     end
        force_read_simple(element, text_before, text_after, data_of)
      end

      public

      ##
      # Initializes a new object that manipulate the display for screen readers
      # of parser.
      #
      # @param parser [Hatemile::Util::Html::HTMLDOMParser] The HTML parser.
      # @param configure [Hatemile::Util::Configure] The configuration of
      #   HaTeMiLe.
      # @param user_agent [String] The user agent of the user.
      def initialize(parser, configure, user_agent = nil)
        @parser = parser
        @configure = configure
        @id_generator = Hatemile::Util::IDGenerator.new('display')
        @shortcut_prefix = get_shortcut_prefix(
          user_agent,
          configure.get_parameter('attribute-accesskey-default')
        )
        @aria_autocomplete_both_before = configure.get_parameter(
          'aria-autocomplete-both-before'
        )
        @aria_autocomplete_both_after = configure.get_parameter(
          'aria-autocomplete-both-after'
        )
        @aria_autocomplete_inline_before = configure.get_parameter(
          'aria-autocomplete-inline-before'
        )
        @aria_autocomplete_inline_after = configure.get_parameter(
          'aria-autocomplete-inline-after'
        )
        @aria_autocomplete_list_before = configure.get_parameter(
          'aria-autocomplete-list-before'
        )
        @aria_autocomplete_list_after = configure.get_parameter(
          'aria-autocomplete-list-after'
        )
        @aria_busy_true_before = configure.get_parameter(
          'aria-busy-true-before'
        )
        @aria_busy_true_after = configure.get_parameter('aria-busy-true-after')
        @aria_checked_false_before = configure.get_parameter(
          'aria-checked-false-before'
        )
        @aria_checked_false_after = configure.get_parameter(
          'aria-checked-false-after'
        )
        @aria_checked_mixed_before = configure.get_parameter(
          'aria-checked-mixed-before'
        )
        @aria_checked_mixed_after = configure.get_parameter(
          'aria-checked-mixed-after'
        )
        @aria_checked_true_before = configure.get_parameter(
          'aria-checked-true-before'
        )
        @aria_checked_true_after = configure.get_parameter(
          'aria-checked-true-after'
        )
        @aria_dropeffect_copy_before = configure.get_parameter(
          'aria-dropeffect-copy-before'
        )
        @aria_dropeffect_copy_after = configure.get_parameter(
          'aria-dropeffect-copy-after'
        )
        @aria_dropeffect_execute_before = configure.get_parameter(
          'aria-dropeffect-execute-before'
        )
        @aria_dropeffect_execute_after = configure.get_parameter(
          'aria-dropeffect-execute-after'
        )
        @aria_dropeffect_link_before = configure.get_parameter(
          'aria-dropeffect-link-before'
        )
        @aria_dropeffect_link_after = configure.get_parameter(
          'aria-dropeffect-link-after'
        )
        @aria_dropeffect_move_before = configure.get_parameter(
          'aria-dropeffect-move-before'
        )
        @aria_dropeffect_move_after = configure.get_parameter(
          'aria-dropeffect-move-after'
        )
        @aria_dropeffect_popup_before = configure.get_parameter(
          'aria-dropeffect-popup-before'
        )
        @aria_dropeffect_popup_after = configure.get_parameter(
          'aria-dropeffect-popup-after'
        )
        @aria_expanded_false_before = configure.get_parameter(
          'aria-expanded-false-before'
        )
        @aria_expanded_false_after = configure.get_parameter(
          'aria-expanded-false-after'
        )
        @aria_expanded_true_before = configure.get_parameter(
          'aria-expanded-true-before'
        )
        @aria_expanded_true_after = configure.get_parameter(
          'aria-expanded-true-after'
        )
        @aria_grabbed_false_before = configure.get_parameter(
          'aria-grabbed-false-before'
        )
        @aria_grabbed_false_after = configure.get_parameter(
          'aria-grabbed-false-after'
        )
        @aria_grabbed_true_before = configure.get_parameter(
          'aria-grabbed-true-before'
        )
        @aria_grabbed_true_after = configure.get_parameter(
          'aria-grabbed-true-after'
        )
        @aria_haspopup_true_before = configure.get_parameter(
          'aria-haspopup-true-before'
        )
        @aria_haspopup_true_after = configure.get_parameter(
          'aria-haspopup-true-after'
        )
        @aria_level_prefix_before = configure.get_parameter(
          'aria-level-prefix-before'
        )
        @aria_level_suffix_before = configure.get_parameter(
          'aria-level-suffix-before'
        )
        @aria_level_prefix_after = configure.get_parameter(
          'aria-level-prefix-after'
        )
        @aria_level_suffix_after = configure.get_parameter(
          'aria-level-suffix-after'
        )
        @aria_value_maximum_prefix_before = configure.get_parameter(
          'aria-value-maximum-prefix-before'
        )
        @aria_value_maximum_suffix_before = configure.get_parameter(
          'aria-value-maximum-suffix-before'
        )
        @aria_value_maximum_prefix_after = configure.get_parameter(
          'aria-value-maximum-prefix-after'
        )
        @aria_value_maximum_suffix_after = configure.get_parameter(
          'aria-value-maximum-suffix-after'
        )
        @aria_value_minimum_prefix_before = configure.get_parameter(
          'aria-value-minimum-prefix-before'
        )
        @aria_value_minimum_suffix_before = configure.get_parameter(
          'aria-value-minimum-suffix-before'
        )
        @aria_value_minimum_prefix_after = configure.get_parameter(
          'aria-value-minimum-prefix-after'
        )
        @aria_value_minimum_suffix_after = configure.get_parameter(
          'aria-value-minimum-suffix-after'
        )
        @aria_orientation_horizontal_before = configure.get_parameter(
          'aria-orientation-horizontal-before'
        )
        @aria_orientation_horizontal_after = configure.get_parameter(
          'aria-orientation-horizontal-after'
        )
        @aria_orientation_vertical_before = configure.get_parameter(
          'aria-orientation-vertical-before'
        )
        @aria_orientation_vertical_after = configure.get_parameter(
          'aria-orientation-vertical-after'
        )
        @aria_pressed_false_before = configure.get_parameter(
          'aria-pressed-false-before'
        )
        @aria_pressed_false_after = configure.get_parameter(
          'aria-pressed-false-after'
        )
        @aria_pressed_mixed_before = configure.get_parameter(
          'aria-pressed-mixed-before'
        )
        @aria_pressed_mixed_after = configure.get_parameter(
          'aria-pressed-mixed-after'
        )
        @aria_pressed_true_before = configure.get_parameter(
          'aria-pressed-true-before'
        )
        @aria_pressed_true_after = configure.get_parameter(
          'aria-pressed-true-after'
        )
        @aria_required_true_before = configure.get_parameter(
          'aria-required-true-before'
        )
        @aria_required_true_after = configure.get_parameter(
          'aria-required-true-after'
        )
        @aria_selected_false_before = configure.get_parameter(
          'aria-selected-false-before'
        )
        @aria_selected_false_after = configure.get_parameter(
          'aria-selected-false-after'
        )
        @aria_selected_true_before = configure.get_parameter(
          'aria-selected-true-before'
        )
        @aria_selected_true_after = configure.get_parameter(
          'aria-selected-true-after'
        )
        @aria_sort_ascending_before = configure.get_parameter(
          'aria-sort-ascending-before'
        )
        @aria_sort_ascending_after = configure.get_parameter(
          'aria-sort-ascending-after'
        )
        @aria_sort_descending_before = configure.get_parameter(
          'aria-sort-descending-before'
        )
        @aria_sort_descending_after = configure.get_parameter(
          'aria-sort-descending-after'
        )
        @aria_sort_other_before = configure.get_parameter(
          'aria-sort-other-before'
        )
        @aria_sort_other_after = configure.get_parameter(
          'aria-sort-other-after'
        )
        @attribute_accesskey_before = configure.get_parameter(
          'attribute-accesskey-before'
        )
        @attribute_accesskey_after = configure.get_parameter(
          'attribute-accesskey-after'
        )
        @attribute_accesskey_prefix_before = configure.get_parameter(
          'attribute-accesskey-prefix-before'
        )
        @attribute_accesskey_suffix_before = configure.get_parameter(
          'attribute-accesskey-suffix-before'
        )
        @attribute_accesskey_prefix_after = configure.get_parameter(
          'attribute-accesskey-prefix-after'
        )
        @attribute_accesskey_suffix_after = configure.get_parameter(
          'attribute-accesskey-suffix-after'
        )
        @attribute_download_before = configure.get_parameter(
          'attribute-download-before'
        )
        @attribute_download_after = configure.get_parameter(
          'attribute-download-after'
        )
        @attribute_headers_prefix_before = configure.get_parameter(
          'attribute-headers-prefix-before'
        )
        @attribute_headers_suffix_before = configure.get_parameter(
          'attribute-headers-suffix-before'
        )
        @attribute_headers_prefix_after = configure.get_parameter(
          'attribute-headers-prefix-after'
        )
        @attribute_headers_suffix_after = configure.get_parameter(
          'attribute-headers-suffix-after'
        )
        @attribute_role_prefix_before = configure.get_parameter(
          'attribute-role-prefix-before'
        )
        @attribute_role_suffix_before = configure.get_parameter(
          'attribute-role-suffix-before'
        )
        @attribute_role_prefix_after = configure.get_parameter(
          'attribute-role-prefix-after'
        )
        @attribute_role_suffix_after = configure.get_parameter(
          'attribute-role-suffix-after'
        )
        @attribute_target_blank_before = configure.get_parameter(
          'attribute-target-blank-before'
        )
        @attribute_target_blank_after = configure.get_parameter(
          'attribute-target-blank-after'
        )
        @list_shortcuts_added = false
        @list_shortcuts_before = nil
        @list_shortcuts_after = nil
      end

      ##
      # @see Hatemile::AccessibleDisplay#display_shortcut
      def display_shortcut(element)
        return unless element.has_attribute?('accesskey')

        description = get_description(element)
        unless element.has_attribute?('title')
          element.set_attribute('title', description)
        end

        generate_list_shortcuts unless @list_shortcuts_added

        keys = element.get_attribute('accesskey').upcase.split(/[ \n\t\r]+/)
        keys.each do |key|
          shortcut = "#{@shortcut_prefix} + #{key}"
          selector = "[#{DATA_ATTRIBUTE_ACCESSKEY_OF}=\"#{key}\"]"

          force_read(
            element,
            shortcut,
            @attribute_accesskey_prefix_before,
            @attribute_accesskey_suffix_before,
            @attribute_accesskey_prefix_after,
            @attribute_accesskey_suffix_after,
            DATA_ATTRIBUTE_ACCESSKEY_OF
          )

          item = @parser.create_element('li')
          item.set_attribute(DATA_ATTRIBUTE_ACCESSKEY_OF, key)
          item.append_text("#{shortcut}: #{description}")

          if !@list_shortcuts_before.nil? &&
             @parser.find(@list_shortcuts_before).find_children(
               selector
             ).first_result.nil?
            @list_shortcuts_before.append_element(item.clone_element)
          end
          unless !@list_shortcuts_after.nil? &&
                 @parser.find(@list_shortcuts_after).find_children(
                   selector
                 ).first_result.nil?
            next
          end
          @list_shortcuts_after.append_element(item.clone_element)
        end
      end

      ##
      # @see Hatemile::AccessibleDisplay#display_all_shortcuts
      def display_all_shortcuts
        elements = @parser.find('[accesskey]').list_results
        elements.each do |element|
          if Hatemile::Util::CommonFunctions.is_valid_element?(element)
            display_shortcut(element)
          end
        end
      end

      ##
      # @see Hatemile::AccessibleDisplay#display_role
      def display_role(element)
        return unless element.has_attribute?('role')

        role_description = get_role_description(element.get_attribute('role'))

        return if role_description.nil?

        force_read(
          element,
          role_description,
          @attribute_role_prefix_before,
          @attribute_role_suffix_before,
          @attribute_role_prefix_after,
          @attribute_role_suffix_after,
          DATA_ROLE_OF
        )
      end

      ##
      # @see Hatemile::AccessibleDisplay#display_all_roles
      def display_all_roles
        elements = @parser.find('[role]').list_results
        elements.each do |element|
          if Hatemile::Util::CommonFunctions.is_valid_element?(element)
            display_role(element)
          end
        end
      end

      ##
      # @see Hatemile::AccessibleDisplay#display_cell_header
      def display_cell_header(table_cell)
        return unless table_cell.has_attribute?('headers')

        text_header = ''
        ids_headers = table_cell.get_attribute('headers').split(/[ \n\t\r]+/)
        ids_headers.each do |id_header|
          header = @parser.find("##{id_header}").first_result

          next if header.nil?

          text_header = if text_header.empty?
                          header.get_text_content.strip
                        else
                          "#{text_header} #{header.get_text_content.strip}"
                        end
        end

        return if text_header.strip.empty?

        force_read(
          table_cell,
          text_header.gsub(/[ \n\t\r]+/, ' ').strip,
          @attribute_headers_prefix_before,
          @attribute_headers_suffix_before,
          @attribute_headers_prefix_after,
          @attribute_headers_suffix_after,
          DATA_ATTRIBUTE_HEADERS_OF
        )
      end

      ##
      # @see Hatemile::AccessibleDisplay#display_all_cell_headers
      def display_all_cell_headers
        elements = @parser.find('td[headers],th[headers]').list_results
        elements.each do |element|
          if Hatemile::Util::CommonFunctions.is_valid_element?(element)
            display_cell_header(element)
          end
        end
      end

      ##
      # @see Hatemile::AccessibleDisplay#display_waiaria_states
      def display_waiaria_states(element)
        if element.has_attribute?('aria-busy') &&
           element.get_attribute('aria-busy') == 'true'
          force_read_simple(
            element,
            @aria_busy_true_before,
            @aria_busy_true_after,
            DATA_ARIA_BUSY_OF
          )
        end
        if element.has_attribute?('aria-checked')
          attribute_value = element.get_attribute('aria-checked')
          if attribute_value == 'true'
            force_read_simple(
              element,
              @aria_checked_true_before,
              @aria_checked_true_after,
              DATA_ARIA_CHECKED_OF
            )
          elsif attribute_value == 'false'
            force_read_simple(
              element,
              @aria_checked_false_before,
              @aria_checked_false_after,
              DATA_ARIA_CHECKED_OF
            )
          elsif attribute_value == 'mixed'
            force_read_simple(
              element,
              @aria_checked_mixed_before,
              @aria_checked_mixed_after,
              DATA_ARIA_CHECKED_OF
            )
          end
        end
        if element.has_attribute?('aria-expanded')
          attribute_value = element.get_attribute('aria-expanded')
          if attribute_value == 'true'
            force_read_simple(
              element,
              @aria_expanded_true_before,
              @aria_expanded_true_after,
              DATA_ARIA_EXPANDED_OF
            )
          elsif attribute_value == 'false'
            force_read_simple(
              element,
              @aria_expanded_false_before,
              @aria_expanded_false_after,
              DATA_ARIA_EXPANDED_OF
            )
          end
        end
        if element.has_attribute?('aria-haspopup') &&
           element.get_attribute('aria-haspopup') == 'true'
          force_read_simple(
            element,
            @aria_haspopup_true_before,
            @aria_haspopup_true_after,
            DATA_ARIA_HASPOPUP_OF
          )
        end
        if element.has_attribute?('aria-level')
          force_read(
            element,
            element.get_attribute('aria-level'),
            @aria_level_prefix_before,
            @aria_level_suffix_before,
            @aria_level_prefix_after,
            @aria_level_suffix_after,
            DATA_ARIA_LEVEL_OF
          )
        end
        if element.has_attribute?('aria-orientation')
          attribute_value = element.get_attribute('aria-orientation')
          if attribute_value == 'vertical'
            force_read_simple(
              element,
              @aria_orientation_vertical_before,
              @aria_orientation_vertical_after,
              DATA_ARIA_ORIENTATION_OF
            )
          elsif attribute_value == 'horizontal'
            force_read_simple(
              element,
              @aria_orientation_horizontal_before,
              @aria_orientation_horizontal_after,
              DATA_ARIA_ORIENTATION_OF
            )
          end
        end
        if element.has_attribute?('aria-pressed')
          attribute_value = element.get_attribute('aria-pressed')
          if attribute_value == 'true'
            force_read_simple(
              element,
              @aria_pressed_true_before,
              @aria_pressed_true_after,
              DATA_ARIA_PRESSED_OF
            )
          elsif attribute_value == 'false'
            force_read_simple(
              element,
              @aria_pressed_false_before,
              @aria_pressed_false_after,
              DATA_ARIA_PRESSED_OF
            )
          elsif attribute_value == 'mixed'
            force_read_simple(
              element,
              @aria_pressed_mixed_before,
              @aria_pressed_mixed_after,
              DATA_ARIA_PRESSED_OF
            )
          end
        end
        if element.has_attribute?('aria-selected')
          attribute_value = element.get_attribute('aria-selected')
          if attribute_value == 'true'
            force_read_simple(
              element,
              @aria_selected_true_before,
              @aria_selected_true_after,
              DATA_ARIA_SELECTED_OF
            )
          elsif attribute_value == 'false'
            force_read_simple(
              element,
              @aria_selected_false_before,
              @aria_selected_false_after,
              DATA_ARIA_SELECTED_OF
            )
          end
        end
        if element.has_attribute?('aria-sort')
          attribute_value = element.get_attribute('aria-sort')
          if attribute_value == 'ascending'
            force_read_simple(
              element,
              @aria_sort_ascending_before,
              @aria_sort_ascending_after,
              DATA_ARIA_SORT_OF
            )
          elsif attribute_value == 'descending'
            force_read_simple(
              element,
              @aria_sort_descending_before,
              @aria_sort_descending_after,
              DATA_ARIA_SORT_OF
            )
          elsif attribute_value == 'other'
            force_read_simple(
              element,
              @aria_sort_other_before,
              @aria_sort_other_after,
              DATA_ARIA_SORT_OF
            )
          end
        end
        if element.has_attribute?('aria-required') &&
           element.get_attribute('aria-required') == 'true'
          force_read_simple(
            element,
            @aria_required_true_before,
            @aria_required_true_after,
            DATA_ARIA_REQUIRED_OF
          )
        end
        if element.has_attribute?('aria-valuemin')
          force_read(
            element,
            element.get_attribute('aria-valuemin'),
            @aria_value_minimum_prefix_before,
            @aria_value_minimum_suffix_before,
            @aria_value_minimum_prefix_after,
            @aria_value_minimum_suffix_after,
            DATA_ARIA_RANGE_MIN_OF
          )
        end
        if element.has_attribute?('aria-valuemax')
          force_read(
            element,
            element.get_attribute('aria-valuemax'),
            @aria_value_maximum_prefix_before,
            @aria_value_maximum_suffix_before,
            @aria_value_maximum_prefix_after,
            @aria_value_maximum_suffix_after,
            DATA_ARIA_RANGE_MAX_OF
          )
        end
        if element.has_attribute?('aria-autocomplete')
          attribute_value = element.get_attribute('aria-autocomplete')
          if attribute_value == 'both'
            force_read_simple(
              element,
              @aria_autocomplete_both_before,
              @aria_autocomplete_both_after,
              DATA_ARIA_AUTOCOMPLETE_OF
            )
          elsif attribute_value == 'inline'
            force_read_simple(
              element,
              @aria_autocomplete_list_before,
              @aria_autocomplete_list_after,
              DATA_ARIA_AUTOCOMPLETE_OF
            )
          elsif attribute_value == 'list'
            force_read_simple(
              element,
              @aria_autocomplete_inline_before,
              @aria_autocomplete_inline_after,
              DATA_ARIA_AUTOCOMPLETE_OF
            )
          end
        end
        if element.has_attribute?('aria-dropeffect')
          attribute_value = element.get_attribute('aria-dropeffect')
          if attribute_value == 'copy'
            force_read_simple(
              element,
              @aria_dropeffect_copy_before,
              @aria_dropeffect_copy_after,
              DATA_ARIA_DROPEFFECT_OF
            )
          elsif attribute_value == 'move'
            force_read_simple(
              element,
              @aria_dropeffect_move_before,
              @aria_dropeffect_move_after,
              DATA_ARIA_DROPEFFECT_OF
            )
          elsif attribute_value == 'link'
            force_read_simple(
              element,
              @aria_dropeffect_link_before,
              @aria_dropeffect_link_after,
              DATA_ARIA_DROPEFFECT_OF
            )
          elsif attribute_value == 'execute'
            force_read_simple(
              element,
              @aria_dropeffect_execute_before,
              @aria_dropeffect_execute_after,
              DATA_ARIA_DROPEFFECT_OF
            )
          elsif attribute_value == 'popup'
            force_read_simple(
              element,
              @aria_dropeffect_popup_before,
              @aria_dropeffect_popup_after,
              DATA_ARIA_DROPEFFECT_OF
            )
          end
        end

        return unless element.has_attribute?('aria-grabbed')

        attribute_value = element.get_attribute('aria-grabbed')
        if attribute_value == 'true'
          force_read_simple(
            element,
            @aria_grabbed_true_before,
            @aria_grabbed_true_after,
            DATA_ARIA_GRABBED_OF
          )
        elsif attribute_value == 'false'
          force_read_simple(
            element,
            @aria_grabbed_false_before,
            @aria_grabbed_false_after,
            DATA_ARIA_GRABBED_OF
          )
        end
      end

      ##
      # @see Hatemile::AccessibleDisplay#display_all_waiaria_states
      def display_all_waiaria_states
        elements = @parser.find(
          '[aria-busy=true],[aria-checked],[aria-dropeffect],' \
          '[aria-expanded],[aria-grabbed],[aria-haspopup],[aria-level],' \
          '[aria-orientation],[aria-pressed],[aria-selected],[aria-sort],' \
          '[aria-required=true],[aria-valuemin],[aria-valuemax],' \
          '[aria-autocomplete]'
        ).list_results
        elements.each do |element|
          if Hatemile::Util::CommonFunctions.is_valid_element?(element)
            display_waiaria_states(element)
          end
        end
      end

      ##
      # @see Hatemile::AccessibleDisplay#display_link_attributes
      def display_link_attributes(link)
        if link.has_attribute?('download')
          force_read_simple(
            link,
            @attribute_download_before,
            @attribute_download_after,
            DATA_ATTRIBUTE_DOWNLOAD_OF
          )
        end
        if link.has_attribute?('target') &&
           link.get_attribute('target') == '_blank'
          force_read_simple(
            link,
            @attribute_target_blank_before,
            @attribute_target_blank_after,
            DATA_ATTRIBUTE_TARGET_OF
          )
        end
      end

      ##
      # @see Hatemile::AccessibleDisplay#display_all_links_attributes
      def display_all_links_attributes
        links = @parser.find('a[download],a[target="_blank"]').list_results
        links.each do |link|
          if Hatemile::Util::CommonFunctions.is_valid_element?(link)
            display_link_attributes(link)
          end
        end
      end
    end
  end
end
