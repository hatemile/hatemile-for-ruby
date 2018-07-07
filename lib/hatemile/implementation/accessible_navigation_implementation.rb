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
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +element+ The element with description.
      # Return:
      # String The description of element.
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
          descriptionIds = if element.has_attribute?('aria-labelledby')
                             element.get_attribute('aria-labelledby').split(/[ \n\t\r]+/)
                           else
                             element.get_attribute('aria-describedby').split(/[ \n\t\r]+/)
                           end
          descriptionIds.each do |descriptionId|
            elementDescription = @parser.find("##{descriptionId}").first_result
            unless elementDescription.nil?
              description = elementDescription.get_text_content
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
      # ---
      #
      # Return:
      # Hatemile::Util::HTMLDOMElement The list of shortcuts of page.
      def generate_list_shortcuts
        container = @parser.find("##{@idContainerShortcuts}").first_result

        htmlList = nil
        if container.nil?
          local = @parser.find('body').first_result
          unless local.nil?
            container = @parser.create_element('div')
            container.set_attribute('id', @idContainerShortcuts)

            textContainer = @parser.create_element('span')
            textContainer.set_attribute('id', @idTextShortcuts)
            textContainer.append_text(@textShortcuts)

            container.append_element(textContainer)
            local.append_element(container)

            execute_fix_skipper(container)
            execute_fix_skipper(textContainer)
          end
        end
        unless container.nil?
          htmlList = @parser.find(container).find_children('ul').first_result
          if htmlList.nil?
            htmlList = @parser.create_element('ul')
            container.append_element(htmlList)
          end
          execute_fix_skipper(htmlList)
        end
        @listShortcutsAdded = true

        htmlList
      end

      ##
      # Generate the list of skippers of page.
      #
      # ---
      #
      # Return:
      # Hatemile::Util::HTMLDOMElement The list of skippers of page.
      def generate_list_skippers
        container = @parser.find("##{@idContainerSkippers}").first_result
        htmlList = nil
        if container.nil?
          local = @parser.find('body').first_result
          unless local.nil?
            container = @parser.create_element('div')
            container.set_attribute('id', @idContainerSkippers)
            local.get_first_element_child.insert_before(container)
          end
        end
        unless container.nil?
          htmlList = @parser.find(container).find_children('ul').first_result
          if htmlList.nil?
            htmlList = @parser.create_element('ul')
            container.append_element(htmlList)
          end
        end
        @listSkippersAdded = true

        htmlList
      end

      ##
      # Generate the list of heading links of page.
      #
      # ---
      #
      # Return:
      # Hatemile::Util::HTMLDOMElement The list of heading links of page.
      def generate_list_heading
        container = @parser.find("##{@idContainerHeading}").first_result
        htmlList = nil
        if container.nil?
          local = @parser.find('body').first_result
          unless local.nil?
            container = @parser.create_element('div')
            container.set_attribute('id', @idContainerHeading)

            textContainer = @parser.create_element('span')
            textContainer.set_attribute('id', @idTextHeading)
            textContainer.append_text(@textHeading)

            container.append_element(textContainer)
            local.append_element(container)

            execute_fix_skipper(container)
            execute_fix_skipper(textContainer)
          end
        end
        unless container.nil?
          htmlList = @parser.find(container).find_children('ol').first_result
          if htmlList.nil?
            htmlList = @parser.create_element('ol')
            container.append_element(htmlList)
          end
          execute_fix_skipper(htmlList)
        end
        htmlList
      end

      ##
      # Returns the level of heading.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +element+ The heading.
      # Return:
      # Integer The level of heading.
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
      # ---
      #
      # Return:
      # Boolean True if the headings of page are sintatic correct or false if not.
      def is_valid_heading
        elements = @parser.find('h1,h2,h3,h4,h5,h6').list_results
        lastLevel = 0
        countMainHeading = 0
        @validateHeading = true
        elements.each do |element|
          level = get_heading_level(element)
          if level == 1
            return false if countMainHeading == 1
            countMainHeading = 1
          end
          return false if (level - lastLevel) > 1
          lastLevel = level
        end
        true
      end

      ##
      # Generate an anchor for the element.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +element+ The element.
      #  2. String +dataAttribute+ The name of attribute that links the element with
      #   the anchor.
      #  3. String +anchorClass+ The HTML class of anchor.
      # Return:
      # Hatemile::Util::HTMLDOMElement The anchor.
      def generate_anchor_for(element, dataAttribute, anchorClass)
        Hatemile::Util::CommonFunctions.generate_id(element, @prefixId)
        anchor = nil
        if @parser.find("[#{dataAttribute}=\"#{element.get_attribute('id')}\"]").first_result.nil?
          if element.get_tag_name == 'A'
            anchor = element
          else
            anchor = @parser.create_element('a')
            Hatemile::Util::CommonFunctions.generate_id(anchor, @prefixId)
            anchor.set_attribute('class', anchorClass)
            element.insert_before(anchor)
          end
          unless anchor.has_attribute?('name')
            anchor.set_attribute('name', anchor.get_attribute('id'))
          end
          anchor.set_attribute(dataAttribute, element.get_attribute('id'))
        end
        anchor
      end

      ##
      # Replace the shortcut of elements, that has the shortcut passed.
      #
      # ---
      #
      # Parameters:
      #   1. String +shortcut+ The shortcut.
      def free_shortcut(shortcut)
        found = false
        alphaNumbers = '1234567890abcdefghijklmnopqrstuvwxyz'
        elements = @parser.find('[accesskey]').list_results
        elements.each do |element|
          shortcuts = element.get_attribute('accesskey').downcase

          next unless Hatemile::Util::CommonFunctions.in_list(shortcuts, shortcut)

          (0..alphaNumbers.length - 1).each do |i|
            key = alphaNumbers[i, i + 1]
            found = true
            elements.each do |elementWithShortcuts|
              shortcuts = elementWithShortcuts.get_attribute('accesskey').downcase

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
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +element+ The element.
      def execute_fix_skipper(element)
        return if @listSkippers.nil?

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
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMElement +element+ The element.
      def execute_fix_shortcut(element)
        fix_shortcut(element) unless @listShortcuts.nil?
      end

      public

      ##
      # Initializes a new object that manipulate the accessibility of the
      # navigation of parser.
      #
      # ---
      #
      # Parameters:
      #  1. Hatemile::Util::HTMLDOMParser +parser+ The HTML parser.
      #  2. Hatemile::Util::Configure +configure+ The configuration of HaTeMiLe.
      #  3. String +userAgent+ The user agent of the user.
      def initialize(parser, configure, userAgent = nil)
        @parser = parser
        @idContainerShortcuts = 'container-shortcuts'
        @idContainerSkippers = 'container-skippers'
        @idContainerHeading = 'container-heading'
        @idTextShortcuts = 'text-shortcuts'
        @idTextHeading = 'text-heading'
        @classSkipperAnchor = 'skipper-anchor'
        @classHeadingAnchor = 'heading-anchor'
        @dataAccessKey = 'data-shortcutdescriptionfor'
        @dataIgnore = 'data-ignoreaccessibilityfix'
        @dataAnchorFor = 'data-anchorfor'
        @dataHeadingAnchorFor = 'data-headinganchorfor'
        @dataHeadingLevel = 'data-headinglevel'
        @prefixId = configure.get_parameter('prefix-generated-ids')
        @textShortcuts = configure.get_parameter('text-shortcuts')
        @textHeading = configure.get_parameter('text-heading')
        @standartPrefix = configure.get_parameter('text-standart-shortcut-prefix')
        @skippers = configure.get_skippers
        @listShortcutsAdded = false
        @listSkippersAdded = false
        @validateHeading = false
        @validHeading = false
        @listSkippers = nil
        @listShortcuts = nil

        if userAgent.nil?
          @prefix = @standartPrefix
        else
          userAgent = userAgent.downcase
          opera = userAgent.include?('opera')
          mac = userAgent.include?('mac')
          konqueror = userAgent.include?('konqueror')
          spoofer = userAgent.include?('spoofer')
          safari = userAgent.include?('applewebkit')
          windows = userAgent.include?('windows')
          chrome = userAgent.include?('chrome')
          firefox = !userAgent.match('firefox/[2-9]|minefield/3').nil?
          ie = userAgent.include?('msie') || userAgent.include?('trident')

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
                      @standartPrefix
                    end
        end
      end

      def fix_shortcut(element)
        return unless element.has_attribute?('accesskey')

        description = get_description(element)
        unless element.has_attribute?('title')
          element.set_attribute('title', description)
        end

        @listShortcuts = generate_list_shortcuts unless @listShortcutsAdded

        return if @listShortcuts.nil?

        keys = element.get_attribute('accesskey').split(/[ \n\t\r]+/)
        keys.each do |key|
          key = key.upcase

          next unless @parser.find(@listShortcuts).find_children("[#{@dataAccessKey}=\"#{key}\"]").first_result.nil?

          item = @parser.create_element('li')
          item.set_attribute(@dataAccessKey, key)
          item.append_text("#{@prefix} + #{key}: #{description}")
          @listShortcuts.append_element(item)
        end
      end

      def fix_shortcuts
        elements = @parser.find('[accesskey]').list_results
        elements.each do |element|
          fix_shortcut(element) unless element.has_attribute?(@dataIgnore)
        end
      end

      def fix_skipper(element, skipper)
        @listSkippers = generate_list_skippers unless @listSkippersAdded

        return if @listSkippers.nil?

        anchor = generate_anchor_for(element, @dataAnchorFor, @classSkipperAnchor)

        return if anchor.nil?

        itemLink = @parser.create_element('li')
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
        Hatemile::Util::CommonFunctions.generate_id(link, @prefixId)

        itemLink.append_element(link)
        @listSkippers.append_element(itemLink)

        execute_fix_shortcut(link)
      end

      def fix_skippers
        @skippers.each do |skipper|
          elements = @parser.find(skipper.get_selector).list_results
          count = elements.size > 1
          index = 1 if count
          shortcuts = skipper.get_shortcuts
          elements.each do |element|
            next if element.has_attribute?(@dataIgnore)

            if count
              defaultText = "#{skipper.get_default_text} #{index}"
              index += 1
            else
              defaultText = skipper.get_default_text
            end
            if !shortcuts.empty?
              fix_skipper(element, Hatemile::Util::Skipper.new(skipper.get_selector, defaultText, shortcuts[shortcuts.size - 1]))
              shortcuts.delete_at(shortcuts.size - 1)
            else
              fix_skipper(element, Hatemile::Util::Skipper.new(skipper.get_selector, defaultText, ''))
            end
          end
        end
      end

      def fix_heading(element)
        @validHeading = is_valid_heading unless @validateHeading

        return unless @validHeading

        anchor = generate_anchor_for(element, @dataHeadingAnchorFor, @classHeadingAnchor)

        return if anchor.nil?

        list = nil
        level = get_heading_level(element)
        if level == 1
          list = generate_list_heading
        else
          superItem = @parser.find("##{@idContainerHeading}").find_descendants("[#{@dataHeadingLevel}=\"#{level - 1}\"]").last_result
          unless superItem.nil?
            list = @parser.find(superItem).find_children('ol').first_result
            if list.nil?
              list = @parser.create_element('ol')
              superItem.append_element(list)
            end
          end
        end

        return if list.nil?

        item = @parser.create_element('li')
        item.set_attribute(@dataHeadingLevel, level.to_s)

        link = @parser.create_element('a')
        link.set_attribute('href', "##{anchor.get_attribute('name')}")
        link.append_text(element.get_text_content)

        item.append_element(link)
        list.append_element(item)
      end

      def fix_headings
        elements = @parser.find('h1,h2,h3,h4,h5,h6').list_results
        elements.each do |element|
          fix_heading(element) unless element.has_attribute?(@dataIgnore)
        end
      end
    end
  end
end
