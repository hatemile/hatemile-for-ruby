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
      # The id of list element that contains the skippers.
      ID_CONTAINER_SKIPPERS = 'container-skippers'.freeze

      ##
      # The id of list element that contains the links for the headings, before
      # the whole content of page.
      ID_CONTAINER_HEADING_BEFORE = 'container-heading-before'.freeze

      ##
      # The id of list element that contains the links for the headings, after
      # the whole content of page.
      ID_CONTAINER_HEADING_AFTER = 'container-heading-after'.freeze

      ##
      # The HTML class of text of description of container of heading links.
      CLASS_TEXT_HEADING = 'text-heading'.freeze

      ##
      # The HTML class of anchor of skipper.
      CLASS_SKIPPER_ANCHOR = 'skipper-anchor'.freeze

      ##
      # The HTML class of anchor of heading link.
      CLASS_HEADING_ANCHOR = 'heading-anchor'.freeze

      ##
      # The HTML class of force link, before it.
      CLASS_FORCE_LINK_BEFORE = 'force-link-before'.freeze

      ##
      # The HTML class of force link, after it.
      CLASS_FORCE_LINK_AFTER = 'force-link-after'.freeze

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
      DATA_ATTRIBUTE_LONG_DESCRIPTION_OF =
        'data-attributelongdescriptionof'.freeze

      protected

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
      def generate_list_heading
        local = @parser.find('body').first_result

        return if local.nil?

        container_before = @parser.find(
          "##{ID_CONTAINER_HEADING_BEFORE}"
        ).first_result
        if container_before.nil? && !@elements_heading_before.empty?
          container_before = @parser.create_element('div')
          container_before.set_attribute('id', ID_CONTAINER_HEADING_BEFORE)

          text_container_before = @parser.create_element('span')
          text_container_before.set_attribute('class', CLASS_TEXT_HEADING)
          text_container_before.append_text(@elements_heading_before)

          container_before.append_element(text_container_before)
          local.prepend_element(container_before)
        end
        unless container_before.nil?
          @list_heading_before = @parser.find(
            container_before
          ).find_children('ol').first_result
          if @list_heading_before.nil?
            @list_heading_before = @parser.create_element('ol')
            container_before.append_element(@list_heading_before)
          end
        end

        container_after = @parser.find(
          "##{ID_CONTAINER_HEADING_AFTER}"
        ).first_result
        if container_after.nil? && !@elements_heading_after.empty?
          container_after = @parser.create_element('div')
          container_after.set_attribute('id', ID_CONTAINER_HEADING_AFTER)

          text_container_after = @parser.create_element('span')
          text_container_after.set_attribute('class', CLASS_TEXT_HEADING)
          text_container_after.append_text(@elements_heading_after)

          container_after.append_element(text_container_after)
          local.append_element(container_after)
        end
        unless container_after.nil?
          @list_heading_after = @parser.find(
            container_after
          ).find_children('ol').first_result
          if @list_heading_after.nil?
            @list_heading_after = @parser.create_element('ol')
            container_after.append_element(@list_heading_after)
          end
        end

        @list_heading_added = true
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
      #
      # @param configure [Hatemile::Util::Configure] The configuration of
      #   HaTeMiLe.
      # @param file_name [String] The file path of skippers configuration.
      # @return [Array<Hash>] The skippers of configuration.
      def get_skippers(configure, file_name)
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
          skipper[:description] = configure.get_parameter(
            skipper_xml.attribute('description').value
          )
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
      def initialize(parser, configure, skipper_file_name = nil)
        @parser = parser
        @id_generator = Hatemile::Util::IDGenerator.new('navigation')
        @elements_heading_before = configure.get_parameter(
          'elements-heading-before'
        )
        @elements_heading_after = configure.get_parameter(
          'elements-heading-after'
        )
        @attribute_long_description_prefix_before = configure.get_parameter(
          'attribute-longdescription-prefix-before'
        )
        @attribute_long_description_suffix_before = configure.get_parameter(
          'attribute-longdescription-suffix-before'
        )
        @attribute_long_description_prefix_after = configure.get_parameter(
          'attribute-longdescription-prefix-after'
        )
        @attribute_long_description_suffix_after = configure.get_parameter(
          'attribute-longdescription-suffix-after'
        )
        @skippers = get_skippers(configure, skipper_file_name)
        @list_skippers_added = false
        @list_heading_added = false
        @validate_heading = false
        @valid_heading = false
        @list_skippers = nil
        @list_heading_before = nil
        @list_heading_after = nil
      end

      ##
      # @see Hatemile::AccessibleNavigation#provide_navigation_by_skipper
      def provide_navigation_by_skipper(element)
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
      # @see Hatemile::AccessibleNavigation#provide_navigation_by_all_skippers
      def provide_navigation_by_all_skippers
        @skippers.each do |skipper|
          elements = @parser.find(skipper[:selector]).list_results
          elements.each do |element|
            next unless Hatemile::Util::CommonFunctions.is_valid_element?(
              element
            )

            provide_navigation_by_skipper(element)
          end
        end
      end

      ##
      # @see Hatemile::AccessibleNavigation#provide_navigation_by_heading
      def provide_navigation_by_heading(heading)
        @valid_heading = valid_heading? unless @validate_heading

        return unless @valid_heading

        anchor = generate_anchor_for(
          heading,
          DATA_HEADING_ANCHOR_FOR,
          CLASS_HEADING_ANCHOR
        )

        return if anchor.nil?

        generate_list_heading unless @list_heading_added
        list_before = nil
        list_after = nil
        level = get_heading_level(heading)
        if level == 1
          list_before = @list_heading_before
          list_after = @list_heading_after
        else
          selector = "[#{DATA_HEADING_LEVEL}=\"#{level - 1}\"]"
          unless @list_heading_before.nil?
            super_item_before = @parser.find(
              @list_heading_before
            ).find_descendants(selector).last_result
            unless super_item_before.nil?
              list_before = @parser.find(
                super_item_before
              ).find_children('ol').first_result
              if list_before.nil?
                list_before = @parser.create_element('ol')
                super_item_before.append_element(list_before)
              end
            end
          end
          unless @list_heading_after.nil?
            super_item_after = @parser.find(
              @list_heading_after
            ).find_descendants(selector).last_result
            unless super_item_after.nil?
              list_after = @parser.find(
                super_item_after
              ).find_children('ol').first_result
              if list_after.nil?
                list_after = @parser.create_element('ol')
                super_item_after.append_element(list_after)
              end
            end
          end
        end

        item = @parser.create_element('li')
        item.set_attribute(DATA_HEADING_LEVEL, level.to_s)

        link = @parser.create_element('a')
        link.set_attribute('href', "##{anchor.get_attribute('name')}")
        link.append_text(heading.get_text_content)
        item.append_element(link)

        unless list_before.nil?
          list_before.append_element(item.clone_element)
        end
        unless list_after.nil?
          list_after.append_element(item.clone_element)
        end
      end

      ##
      # @see Hatemile::AccessibleNavigation#provide_navigation_by_all_headings
      def provide_navigation_by_all_headings
        headings = @parser.find('h1,h2,h3,h4,h5,h6').list_results
        headings.each do |heading|
          if Hatemile::Util::CommonFunctions.is_valid_element?(heading)
            provide_navigation_by_heading(heading)
          end
        end
      end

      ##
      # @see Hatemile::AccessibleNavigation#provide_navigation_to_long_description
      def provide_navigation_to_long_description(image)
        unless image.has_attribute?('longdesc') && image.has_attribute?('alt')
          return
        end

        @id_generator.generate_id(image)
        id = image.get_attribute('id')

        selector = "[#{DATA_ATTRIBUTE_LONG_DESCRIPTION_OF}=\"#{id}\"]"
        return unless @parser.find(selector).first_result.nil?

        alternative_text = image.get_attribute('alt').gsub(
          /[ \n\t\r]+/,
          ' '
        ).strip
        unless @attribute_long_description_prefix_before.empty? &&
               @attribute_long_description_suffix_before.empty?
          before_text = "#{@attribute_long_description_prefix_before}" \
                        "#{alternative_text}" \
                        "#{@attribute_long_description_suffix_before}"
          before_anchor = @parser.create_element('a')
          before_anchor.set_attribute('href', image.get_attribute('longdesc'))
          before_anchor.set_attribute('target', '_blank')
          before_anchor.set_attribute(DATA_ATTRIBUTE_LONG_DESCRIPTION_OF, id)
          before_anchor.set_attribute('class', CLASS_FORCE_LINK_BEFORE)
          before_anchor.append_text(before_text)
          image.insert_after(before_anchor)
        end
        unless @attribute_long_description_prefix_after.empty? &&
               @attribute_long_description_suffix_after.empty?
          after_text = "#{@attribute_long_description_prefix_after}" \
                        "#{alternative_text}" \
                        "#{@attribute_long_description_suffix_after}"
          after_anchor = @parser.create_element('a')
          after_anchor.set_attribute('href', image.get_attribute('longdesc'))
          after_anchor.set_attribute('target', '_blank')
          after_anchor.set_attribute(DATA_ATTRIBUTE_LONG_DESCRIPTION_OF, id)
          after_anchor.set_attribute('class', CLASS_FORCE_LINK_AFTER)
          after_anchor.append_text(after_text)
          image.insert_after(after_anchor)
        end
      end

      ##
      # @see Hatemile::AccessibleNavigation#provide_navigation_to_all_long_descriptions
      def provide_navigation_to_all_long_descriptions
        images = @parser.find('[alt][longdesc]').list_results
        images.each do |image|
          if Hatemile::Util::CommonFunctions.is_valid_element?(image)
            provide_navigation_to_long_description(image)
          end
        end
      end
    end
  end
end
