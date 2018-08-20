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
      # The id of list element that contains the description of shortcuts.
      ID_CONTAINER_SHORTCUTS = 'container-shortcuts'.freeze

      ##
      # The id of text of description of container of shortcuts descriptions.
      ID_TEXT_SHORTCUTS = 'text-shortcuts'.freeze

      ##
      # The name of attribute that link the list item element with the shortcut.
      DATA_ACCESS_KEY = 'data-shortcutdescriptionfor'.freeze

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
        @id_generator = Hatemile::Util::IDGenerator.new('display')
        @text_shortcuts = configure.get_parameter('text-shortcuts')
        @shortcut_prefix = get_shortcut_prefix(
          user_agent,
          configure.get_parameter('text-standart-shortcut-prefix')
        )
        @list_shortcuts_added = false
        @list_shortcuts = nil
      end

      ##
      # @see Hatemile::AccessibleDisplay#fix_shortcut
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
          item.append_text("#{@shortcut_prefix} + #{key}: #{description}")
          @list_shortcuts.append_element(item)
        end
      end

      ##
      # @see Hatemile::AccessibleDisplay#fix_shortcuts
      def fix_shortcuts
        elements = @parser.find('[accesskey]').list_results
        elements.each do |element|
          if Hatemile::Util::CommonFunctions.is_valid_element?(element)
            fix_shortcut(element)
          end
        end
      end
    end
  end
end
