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

require File.dirname(__FILE__) + '/../accessible_navigation.rb'
require File.dirname(__FILE__) + '/../util/skipper.rb'

module Hatemile
  module Implementation
    ##
    # The AccessibleNavigationImplementation class is official implementation of
    # AccessibleNavigation interface.
    class AccessibleNavigationImplementation < AccessibleNavigation
      public_class_method :new

      protected

      ##
      # Returns the description of element.
      #
      # @param element [Hatemile::Util::HTMLDOMElement] The element with
      #   description.
      # @return [String] The description of element.
      def get_description(element)
        description = nil
        if element.has_attribute?('title')
          description = element.get_attribute('title')
        elsif element.has_attribute?('aria-label')
          description = element.get_attribute('aria-label')
        elsif element.has_attribute?('alt')
          description = element.get_attribute('alt')
        elsif element.has_attribute?('label')
          description = element.get_attribute('label')
        elsif element.has_attribute?('aria-labelledby') || element.has_attribute?('aria-describedby')
          description_ids = if element.has_attribute?('aria-labelledby')
                              element.get_attribute('aria-labelledby').split(/[ \n\t\r]+/)
                            else
                              element.get_attribute('aria-describedby').split(/[ \n\t\r]+/)
                            end
          description_ids.each do |description_id|
            element_description = @parser.find("##{description_id}").first_result
            unless element_description.nil?
              description = element_description.get_text_content
              break
            end
          end
        elsif (element.get_tag_name == 'INPUT') && element.has_attribute?('type')
          type = element.get_attribute('type').downcase
          if ((type == 'button') || (type == 'submit') || (type == 'reset')) && element.has_attribute?('value')
            description = element.get_attribute('value')
          end
        end
        description = element.get_text_content if description.nil?
        description.gsub(/[ \n\t\r]+/, ' ')
      end

      ##
      # Generate the list of shortcuts of page.
      #
      # @return [Hatemile::Util::HTMLDOMElement] The list of shortcuts of page.
      def generate_list_shortcuts
        container = @parser.find("##{@id_container_shortcuts}").first_result

        html_list = nil
        if container.nil?
          local = @parser.find('body').first_result
          unless local.nil?
            container = @parser.create_element('div')
            container.set_attribute('id', @id_container_shortcuts)

            text_container = @parser.create_element('span')
            text_container.set_attribute('id', @id_text_shortcuts)
            text_container.append_text(@text_shortcuts)

            container.append_element(text_container)
            local.append_element(container)

            execute_fix_skipper(container)
            execute_fix_skipper(text_container)
          end
        end
        unless container.nil?
          html_list = @parser.find(container).find_children('ul').first_result
          if html_list.nil?
            html_list = @parser.create_element('ul')
            container.append_element(html_list)
          end
          execute_fix_skipper(html_list)
        end
        @list_shortcuts_added = true

        html_list
      end

      ##
      # Generate the list of skippers of page.
      #
      # @return [Hatemile::Util::HTMLDOMElement] The list of skippers of page.
      def generate_list_skippers
        container = @parser.find("##{@id_container_skippers}").first_result
        html_list = nil
        if container.nil?
          local = @parser.find('body').first_result
          unless local.nil?
            container = @parser.create_element('div')
            container.set_attribute('id', @id_container_skippers)
            local.get_first_element_child.insert_before(container)
          end
        end
        unless container.nil?
          html_list = @parser.find(container).find_children('ul').first_result
          if html_list.nil?
            html_list = @parser.create_element('ul')
            container.append_element(html_list)
          end
        end
        @list_skippers_added = true

        html_list
      end

      ##
      # Generate the list of heading links of page.
      #
      # @return [Hatemile::Util::HTMLDOMElement] The list of heading links of
      #   page.
      def generate_list_heading
        container = @parser.find("##{@id_container_heading}").first_result
        html_list = nil
        if container.nil?
          local = @parser.find('body').first_result
          unless local.nil?
            container = @parser.create_element('div')
            container.set_attribute('id', @id_container_heading)

            text_container = @parser.create_element('span')
            text_container.set_attribute('id', @id_text_heading)
            text_container.append_text(@text_heading)

            container.append_element(text_container)
            local.append_element(container)

            execute_fix_skipper(container)
            execute_fix_skipper(text_container)
          end
        end
        unless container.nil?
          html_list = @parser.find(container).find_children('ol').first_result
          if html_list.nil?
            html_list = @parser.create_element('ol')
            container.append_element(html_list)
          end
          execute_fix_skipper(html_list)
        end
        html_list
      end

      ##
      # Returns the level of heading.
      #
      # @param element [Hatemile::Util::HTMLDOMElement] The heading.
      # @return [Integer] The level of heading.
      def get_heading_level(element)
        tag = element.get_tag_name
        return 1 if tag == 'H1'
        return 2 if tag == 'H2'
        return 3 if tag == 'H3'
        return 4 if tag == 'H4'
        return 5 if tag == 'H5'
        return 6 if tag == 'H6'
        -1
      end

      ##
      # Inform if the headings of page are sintatic correct.
      #
      # @return [Boolean] True if the headings of page are sintatic correct or
      #   false if not.
      def is_valid_heading
        elements = @parser.find('h1,h2,h3,h4,h5,h6').list_results
        last_level = 0
        count_main_heading = 0
        @validate_heading = true
        elements.each do |element|
          level = get_heading_level(element)
          if level == 1
            return false if count_main_heading == 1
            count_main_heading = 1
          end
          return false if (level - last_level) > 1
          last_level = level
        end
        true
      end

      ##
      # Generate an anchor for the element.
      #
      # @param element [Hatemile::Util::HTMLDOMElement] The element.
      # @param data_attribute [String] The name of attribute that links the
      #   element with the anchor.
      # @param anchor_class [String] The HTML class of anchor.
      # @return [Hatemile::Util::HTMLDOMElement] The anchor.
      def generate_anchor_for(element, data_attribute, anchor_class)
        Hatemile::Util::CommonFunctions.generate_id(element, @prefix_id)
        anchor = nil
        if @parser.find("[#{data_attribute}=\"#{element.get_attribute('id')}\"]").first_result.nil?
          if element.get_tag_name == 'A'
            anchor = element
          else
            anchor = @parser.create_element('a')
            Hatemile::Util::CommonFunctions.generate_id(anchor, @prefix_id)
            anchor.set_attribute('class', anchor_class)
            element.insert_before(anchor)
          end
          unless anchor.has_attribute?('name')
            anchor.set_attribute('name', anchor.get_attribute('id'))
          end
          anchor.set_attribute(data_attribute, element.get_attribute('id'))
        end
        anchor
      end

      ##
      # Replace the shortcut of elements, that has the shortcut passed.
      #
      # @param shortcut [String] The shortcut.
      # @return [void]
      def free_shortcut(shortcut)
        found = false
        alpha_numbers = '1234567890abcdefghijklmnopqrstuvwxyz'
        elements = @parser.find('[accesskey]').list_results
        elements.each do |element|
          shortcuts = element.get_attribute('accesskey').downcase

          next unless Hatemile::Util::CommonFunctions.in_list(shortcuts, shortcut)

          (0..alpha_numbers.length - 1).each do |i|
            key = alpha_numbers[i, i + 1]
            found = true
            elements.each do |element_with_shortcuts|
              shortcuts = element_with_shortcuts.get_attribute('accesskey').downcase

              next unless Hatemile::Util::CommonFunctions.in_list(shortcuts, key)

              element.set_attribute('accesskey', key)
              found = false
              break
            end
            break if found
          end
          break if found
        end
      end

      ##
      # Call fix_skipper method for element, if the page has the container of
      # skippers.
      #
      # @param element [Hatemile::Util::HTMLDOMElement] The element.
      # @return [void]
      def execute_fix_skipper(element)
        return if @list_skippers.nil?

        @skippers.each do |skipper|
          if @parser.find(skipper.get_selector).list_results.include?(element)
            fix_skipper(element, skipper)
          end
        end
      end

      ##
      # Call fix_shortcut method for element, if the page has the container of
      # shortcuts.
      #
      # @param element [Hatemile::Util::HTMLDOMElement] The element.
      # @return [void]
      def execute_fix_shortcut(element)
        fix_shortcut(element) unless @list_shortcuts.nil?
      end

      public

      ##
      # Initializes a new object that manipulate the accessibility of the
      # navigation of parser.
      #
      # @param parser [Hatemile::Util::HTMLDOMParser] The HTML parser.
      # @param configure [Hatemile::Util::Configure] The configuration of
      #   HaTeMiLe.
      # @param user_agent [String] The user agent of the user.
      def initialize(parser, configure, user_agent = nil)
        @parser = parser
        @id_container_shortcuts = 'container-shortcuts'
        @id_container_skippers = 'container-skippers'
        @id_container_heading = 'container-heading'
        @id_text_shortcuts = 'text-shortcuts'
        @id_text_heading = 'text-heading'
        @class_skipper_anchor = 'skipper-anchor'
        @class_heading_anchor = 'heading-anchor'
        @data_access_key = 'data-shortcutdescriptionfor'
        @data_ignore = 'data-ignoreaccessibilityfix'
        @data_anchor_for = 'data-anchorfor'
        @data_heading_anchor_for = 'data-headinganchorfor'
        @data_heading_level = 'data-headinglevel'
        @prefix_id = configure.get_parameter('prefix-generated-ids')
        @text_shortcuts = configure.get_parameter('text-shortcuts')
        @text_heading = configure.get_parameter('text-heading')
        @standart_prefix = configure.get_parameter('text-standart-shortcut-prefix')
        @skippers = configure.get_skippers
        @list_shortcuts_added = false
        @list_skippers_added = false
        @validate_heading = false
        @valid_heading = false
        @list_skippers = nil
        @list_shortcuts = nil

        if user_agent.nil?
          @prefix = @standart_prefix
        else
          user_agent = user_agent.downcase
          opera = user_agent.include?('opera')
          mac = user_agent.include?('mac')
          konqueror = user_agent.include?('konqueror')
          spoofer = user_agent.include?('spoofer')
          safari = user_agent.include?('applewebkit')
          windows = user_agent.include?('windows')
          chrome = user_agent.include?('chrome')
          firefox = !user_agent.match('firefox/[2-9]|minefield/3').nil?
          ie = user_agent.include?('msie') || user_agent.include?('trident')

          @prefix = if opera
                      'SHIFT + ESC'
                    elsif chrome && mac && !spoofer
                      'CTRL + OPTION'
                    elsif safari && !windows && !spoofer
                      'CTRL + ALT'
                    elsif !windows && (safari || mac || konqueror)
                      'CTRL'
                    elsif firefox
                      'ALT + SHIFT'
                    elsif chrome || ie
                      'ALT'
                    else
                      @standart_prefix
                    end
        end
      end

      def fix_shortcut(element)
        return unless element.has_attribute?('accesskey')

        description = get_description(element)
        unless element.has_attribute?('title')
          element.set_attribute('title', description)
        end

        @list_shortcuts = generate_list_shortcuts unless @list_shortcuts_added

        return if @list_shortcuts.nil?

        keys = element.get_attribute('accesskey').split(/[ \n\t\r]+/)
        keys.each do |key|
          key = key.upcase

          next unless @parser.find(@list_shortcuts).find_children("[#{@data_access_key}=\"#{key}\"]").first_result.nil?

          item = @parser.create_element('li')
          item.set_attribute(@data_access_key, key)
          item.append_text("#{@prefix} + #{key}: #{description}")
          @list_shortcuts.append_element(item)
        end
      end

      def fix_shortcuts
        elements = @parser.find('[accesskey]').list_results
        elements.each do |element|
          fix_shortcut(element) unless element.has_attribute?(@data_ignore)
        end
      end

      def fix_skipper(element, skipper)
        @list_skippers = generate_list_skippers unless @list_skippers_added

        return if @list_skippers.nil?

        anchor = generate_anchor_for(element, @data_anchor_for, @class_skipper_anchor)

        return if anchor.nil?

        item_link = @parser.create_element('li')
        link = @parser.create_element('a')
        link.set_attribute('href', "##{anchor.get_attribute('name')}")
        link.append_text(skipper.get_default_text)

        shortcuts = skipper.get_shortcuts
        unless shortcuts.empty?
          shortcut = shortcuts[0]
          unless shortcut.empty?
            free_shortcut(shortcut)
            link.set_attribute('accesskey', shortcut)
          end
        end
        Hatemile::Util::CommonFunctions.generate_id(link, @prefix_id)

        item_link.append_element(link)
        @list_skippers.append_element(item_link)

        execute_fix_shortcut(link)
      end

      def fix_skippers
        @skippers.each do |skipper|
          elements = @parser.find(skipper.get_selector).list_results
          count = elements.size > 1
          index = 1 if count
          shortcuts = skipper.get_shortcuts
          elements.each do |element|
            next if element.has_attribute?(@data_ignore)

            if count
              default_text = "#{skipper.get_default_text} #{index}"
              index += 1
            else
              default_text = skipper.get_default_text
            end
            if !shortcuts.empty?
              fix_skipper(element, Hatemile::Util::Skipper.new(skipper.get_selector, default_text, shortcuts[shortcuts.size - 1]))
              shortcuts.delete_at(shortcuts.size - 1)
            else
              fix_skipper(element, Hatemile::Util::Skipper.new(skipper.get_selector, default_text, ''))
            end
          end
        end
      end

      def fix_heading(element)
        @valid_heading = is_valid_heading unless @validate_heading

        return unless @valid_heading

        anchor = generate_anchor_for(element, @data_heading_anchor_for, @class_heading_anchor)

        return if anchor.nil?

        list = nil
        level = get_heading_level(element)
        if level == 1
          list = generate_list_heading
        else
          super_item = @parser.find("##{@id_container_heading}").find_descendants("[#{@data_heading_level}=\"#{level - 1}\"]").last_result
          unless super_item.nil?
            list = @parser.find(super_item).find_children('ol').first_result
            if list.nil?
              list = @parser.create_element('ol')
              super_item.append_element(list)
            end
          end
        end

        return if list.nil?

        item = @parser.create_element('li')
        item.set_attribute(@data_heading_level, level.to_s)

        link = @parser.create_element('a')
        link.set_attribute('href', "##{anchor.get_attribute('name')}")
        link.append_text(element.get_text_content)

        item.append_element(link)
        list.append_element(item)
      end

      def fix_headings
        elements = @parser.find('h1,h2,h3,h4,h5,h6').list_results
        elements.each do |element|
          fix_heading(element) unless element.has_attribute?(@data_ignore)
        end
      end
    end
  end
end
