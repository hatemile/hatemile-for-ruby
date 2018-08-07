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
require File.join(File.dirname(File.dirname(__FILE__)), 'accessible_navigation')
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
    # The AccessibleNavigationImplementation class is official implementation of
    # AccessibleNavigation interface.
    class AccessibleNavigationImplementation < AccessibleNavigation
      public_class_method :new

      ##
      # The id of list element that contains the description of shortcuts.
      ID_CONTAINER_SHORTCUTS = 'container-shortcuts'.freeze

      ##
      # The id of list element that contains the skippers.
      ID_CONTAINER_SKIPPERS = 'container-skippers'.freeze

      ##
      # The id of list element that contains the links for the headings.
      ID_CONTAINER_HEADING = 'container-heading'.freeze

      ##
      # The id of text of description of container of shortcuts descriptions.
      ID_TEXT_SHORTCUTS = 'text-shortcuts'.freeze

      ##
      # The id of text of description of container of heading links.
      ID_TEXT_HEADING = 'text-heading'.freeze

      ##
      # The HTML class of anchor of skipper.
      CLASS_SKIPPER_ANCHOR = 'skipper-anchor'.freeze

      ##
      # The HTML class of anchor of heading link.
      CLASS_HEADING_ANCHOR = 'heading-anchor'.freeze

      ##
      # The HTML class of element for show the long description of image.
      CLASS_LONG_DESCRIPTION_LINK = 'longdescription-link'.freeze

      ##
      # The name of attribute that link the list item element with the shortcut.
      DATA_ACCESS_KEY = 'data-shortcutdescriptionfor'.freeze

      ##
      # The name of attribute that links the anchor of skipper with the element.
      DATA_ANCHOR_FOR = 'data-anchorfor'.freeze

      ##
      # The name of attribute that links the anchor of heading link with
      # heading.
      DATA_HEADING_ANCHOR_FOR = 'data-headinganchorfor'.freeze

      ##
      # The name of attribute that indicates the level of heading of link.
      DATA_HEADING_LEVEL = 'data-headinglevel'.freeze

      ##
      # The name of attribute that link the anchor of long description with the
      # image.
      DATA_LONG_DESCRIPTION_FOR_IMAGE = 'data-longdescriptionfor'.freeze

      protected

      ##
      # Returns the description of element.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element with
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
        elsif (element.get_tag_name == 'INPUT') &&
              element.has_attribute?('type')
          type = element.get_attribute('type').downcase
          if ((type == 'button') || (type == 'submit') || (type == 'reset')) &&
             element.has_attribute?('value')
            description = element.get_attribute('value')
          end
        end
        description = element.get_text_content if description.nil?
        description.gsub(/[ \n\t\r]+/, ' ').strip
      end

      ##
      # Generate the list of shortcuts of page.
      #
      # @return [Hatemile::Util::Html::HTMLDOMElement] The list of shortcuts of
      #   page.
      def generate_list_shortcuts
        container = @parser.find("##{ID_CONTAINER_SHORTCUTS}").first_result

        html_list = nil
        if container.nil?
          local = @parser.find('body').first_result
          unless local.nil?
            container = @parser.create_element('div')
            container.set_attribute('id', ID_CONTAINER_SHORTCUTS)

            text_container = @parser.create_element('span')
            text_container.set_attribute('id', ID_TEXT_SHORTCUTS)
            text_container.append_text(@text_shortcuts)

            container.append_element(text_container)
            local.append_element(container)
          end
        end
        unless container.nil?
          html_list = @parser.find(container).find_children('ul').first_result
          if html_list.nil?
            html_list = @parser.create_element('ul')
            container.append_element(html_list)
          end
        end
        @list_shortcuts_added = true

        html_list
      end

      ##
      # Generate the list of skippers of page.
      #
      # @return [Hatemile::Util::Html::HTMLDOMElement] The list of skippers of
      #   page.
      def generate_list_skippers
        container = @parser.find("##{ID_CONTAINER_SKIPPERS}").first_result
        html_list = nil
        if container.nil?
          local = @parser.find('body').first_result
          unless local.nil?
            container = @parser.create_element('div')
            container.set_attribute('id', ID_CONTAINER_SKIPPERS)
            local.prepend_element(container)
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
      # @return [Hatemile::Util::Html::HTMLDOMElement] The list of heading links
      #   of page.
      def generate_list_heading
        container = @parser.find("##{ID_CONTAINER_HEADING}").first_result
        html_list = nil
        if container.nil?
          local = @parser.find('body').first_result
          unless local.nil?
            container = @parser.create_element('div')
            container.set_attribute('id', ID_CONTAINER_HEADING)

            text_container = @parser.create_element('span')
            text_container.set_attribute('id', ID_TEXT_HEADING)
            text_container.append_text(@text_heading)

            container.append_element(text_container)
            local.append_element(container)
          end
        end
        unless container.nil?
          html_list = @parser.find(container).find_children('ol').first_result
          if html_list.nil?
            html_list = @parser.create_element('ol')
            container.append_element(html_list)
          end
        end
        html_list
      end

      ##
      # Returns the level of heading.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The heading.
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
      def valid_heading?
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
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      # @param data_attribute [String] The name of attribute that links the
      #   element with the anchor.
      # @param anchor_class [String] The HTML class of anchor.
      # @return [Hatemile::Util::Html::HTMLDOMElement] The anchor.
      def generate_anchor_for(element, data_attribute, anchor_class)
        @id_generator.generate_id(element)
        anchor = nil
        if @parser.find(
          "[#{data_attribute}=\"#{element.get_attribute('id')}\"]"
        ).first_result.nil?
          if element.get_tag_name == 'A'
            anchor = element
          else
            anchor = @parser.create_element('a')
            @id_generator.generate_id(anchor)
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

          unless Hatemile::Util::CommonFunctions.in_list?(shortcuts, shortcut)
            next
          end

          (0..alpha_numbers.length - 1).each do |i|
            key = alpha_numbers[i, i + 1]
            found = true
            elements.each do |element_with_shortcuts|
              shortcuts = element_with_shortcuts.get_attribute(
                'accesskey'
              ).downcase

              unless Hatemile::Util::CommonFunctions.in_list?(shortcuts, key)
                next
              end

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
      # Returns the skippers of configuration.
      #
      # @param file_name [String] The file path of skippers configuration.
      # @return [Array<Hash>] The skippers of configuration.
      def get_skippers(file_name)
        skippers = []
        if file_name.nil?
          file_name = File.join(
            File.dirname(File.dirname(File.dirname(__FILE__))),
            'skippers.xml'
          )
        end
        document = REXML::Document.new(File.read(file_name))
        document.elements.each('skippers/skipper') do |skipper_xml|
          skipper = {}
          skipper[:selector] = skipper_xml.attribute('selector').value
          skipper[:description] = skipper_xml.attribute('description').value
          skipper[:shortcut] = skipper_xml.attribute('shortcut').value
          skippers.push(skipper)
        end
        skippers
      end

      public

      ##
      # Initializes a new object that manipulate the accessibility of the
      # navigation of parser.
      #
      # @param parser [Hatemile::Util::Html::HTMLDOMParser] The HTML parser.
      # @param configure [Hatemile::Util::Configure] The configuration of
      #   HaTeMiLe.
      # @param skipper_file_name [String] The file path of skippers
      #   configuration.
      # @param user_agent [String] The user agent of the user.
      def initialize(
        parser,
        configure,
        skipper_file_name = nil,
        user_agent = nil
      )
        @parser = parser
        @id_generator = Hatemile::Util::IDGenerator.new('navigation')
        @text_shortcuts = configure.get_parameter('text-shortcuts')
        @text_heading = configure.get_parameter('text-heading')
        @standart_prefix = configure.get_parameter(
          'text-standart-shortcut-prefix'
        )
        @prefix_long_description_link = configure.get_parameter(
          'prefix-longdescription'
        )
        @suffix_long_description_link = configure.get_parameter(
          'suffix-longdescription'
        )
        @skippers = get_skippers(skipper_file_name)
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

      ##
      # @see Hatemile::AccessibleNavigation#fix_shortcut
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

          unless @parser.find(@list_shortcuts).find_children(
            "[#{DATA_ACCESS_KEY}=\"#{key}\"]"
          ).first_result.nil?
            next
          end

          item = @parser.create_element('li')
          item.set_attribute(DATA_ACCESS_KEY, key)
          item.append_text("#{@prefix} + #{key}: #{description}")
          @list_shortcuts.append_element(item)
        end
      end

      ##
      # @see Hatemile::AccessibleNavigation#fix_shortcuts
      def fix_shortcuts
        elements = @parser.find('[accesskey]').list_results
        elements.each do |element|
          if Hatemile::Util::CommonFunctions.is_valid_element?(element)
            fix_shortcut(element)
          end
        end
      end

      ##
      # @see Hatemile::AccessibleNavigation#fix_skipper
      def fix_skipper(element)
        skipper = nil
        @skippers.each do |auxiliar_skipper|
          elements = @parser.find(auxiliar_skipper[:selector]).list_results
          if elements.include?(element)
            skipper = auxiliar_skipper
            break
          end
        end

        return if skipper.nil?

        @list_skippers = generate_list_skippers unless @list_skippers_added

        return if @list_skippers.nil?

        anchor = generate_anchor_for(
          element,
          DATA_ANCHOR_FOR,
          CLASS_SKIPPER_ANCHOR
        )

        return if anchor.nil?

        item_link = @parser.create_element('li')
        link = @parser.create_element('a')
        link.set_attribute('href', "##{anchor.get_attribute('name')}")
        link.append_text(skipper[:description])

        free_shortcut(skipper[:shortcut])
        link.set_attribute('accesskey', skipper[:shortcut])

        @id_generator.generate_id(link)

        item_link.append_element(link)
        @list_skippers.append_element(item_link)
      end

      ##
      # @see Hatemile::AccessibleNavigation#fix_skippers
      def fix_skippers
        @skippers.each do |skipper|
          elements = @parser.find(skipper[:selector]).list_results
          elements.each do |element|
            next unless Hatemile::Util::CommonFunctions.is_valid_element?(
              element
            )

            fix_skipper(element)
          end
        end
      end

      ##
      # @see Hatemile::AccessibleNavigation#fix_heading
      def fix_heading(element)
        @valid_heading = valid_heading? unless @validate_heading

        return unless @valid_heading

        anchor = generate_anchor_for(
          element,
          DATA_HEADING_ANCHOR_FOR,
          CLASS_HEADING_ANCHOR
        )

        return if anchor.nil?

        list = nil
        level = get_heading_level(element)
        if level == 1
          list = generate_list_heading
        else
          super_item = @parser.find(
            "##{ID_CONTAINER_HEADING}"
          ).find_descendants(
            "[#{DATA_HEADING_LEVEL}=\"#{level - 1}\"]"
          ).last_result
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
        item.set_attribute(DATA_HEADING_LEVEL, level.to_s)

        link = @parser.create_element('a')
        link.set_attribute('href', "##{anchor.get_attribute('name')}")
        link.append_text(element.get_text_content)

        item.append_element(link)
        list.append_element(item)
      end

      ##
      # @see Hatemile::AccessibleNavigation#fix_headings
      def fix_headings
        elements = @parser.find('h1,h2,h3,h4,h5,h6').list_results
        elements.each do |element|
          if Hatemile::Util::CommonFunctions.is_valid_element?(element)
            fix_heading(element)
          end
        end
      end

      ##
      # @see Hatemile::AccessibleNavigation#fix_long_description
      def fix_long_description(element)
        return unless element.has_attribute?('longdesc')

        @id_generator.generate_id(element)
        id = element.get_attribute('id')

        selector = "[#{DATA_LONG_DESCRIPTION_FOR_IMAGE}=\"#{id}\"]"
        return unless @parser.find(selector).first_result.nil?

        text = if element.has_attribute?('alt')
                 "#{@prefix_long_description_link} " \
                 "#{element.get_attribute('alt')} " \
                 "#{@suffix_long_description_link}"
               else
                 "#{@prefix_long_description_link} " \
                 "#{@suffix_long_description_link}"
               end
        anchor = @parser.create_element('a')
        anchor.set_attribute('href', element.get_attribute('longdesc'))
        anchor.set_attribute('target', '_blank')
        anchor.set_attribute(DATA_LONG_DESCRIPTION_FOR_IMAGE, id)
        anchor.set_attribute('class', CLASS_LONG_DESCRIPTION_LINK)
        anchor.append_text(text)
        element.insert_after(anchor)
      end

      ##
      # @see Hatemile::AccessibleNavigation#fix_long_descriptions
      def fix_long_descriptions
        elements = @parser.find('[longdesc]').list_results
        elements.each do |element|
          if Hatemile::Util::CommonFunctions.is_valid_element?(element)
            fix_long_description(element)
          end
        end
      end
    end
  end
end
