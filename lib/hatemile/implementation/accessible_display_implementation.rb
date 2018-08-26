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
      # The name of attribute that links the description of shortcut of element.
      DATA_ATTRIBUTE_ACCESSKEY_OF = 'data-attributeaccesskeyof'.freeze

      ##
      # The name of attribute that links the content of header cell with the
      # data cell.
      DATA_ATTRIBUTE_HEADERS_OF = 'data-headersof'.freeze

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
    end
  end
end
