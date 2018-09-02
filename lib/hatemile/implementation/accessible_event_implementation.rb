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

require File.join(File.dirname(File.dirname(__FILE__)), 'accessible_event')
require File.join(File.dirname(File.dirname(__FILE__)), 'helper')
require File.join(
  File.dirname(File.dirname(__FILE__)),
  'util',
  'common_functions'
)
require File.join(
  File.dirname(File.dirname(__FILE__)),
  'util',
  'html',
  'html_dom_parser'
)
require File.join(File.dirname(File.dirname(__FILE__)), 'util', 'id_generator')

##
# The Hatemile module contains the interfaces with the acessibility solutions.
module Hatemile
  ##
  # The Hatemile::Implementation module contains the official implementation of
  # interfaces solutions.
  module Implementation
    ##
    # The AccessibleEventImplementation class is official implementation of
    # AccessibleEvent interface.
    class AccessibleEventImplementation < AccessibleEvent
      public_class_method :new

      ##
      # The id of script element that replace the event listener methods.
      ID_SCRIPT_EVENT_LISTENER = 'script-eventlistener'.freeze

      ##
      # The id of script element that contains the list of elements that has
      # inaccessible events.
      ID_LIST_IDS_SCRIPT = 'list-ids-script'.freeze

      ##
      # The id of script element that modify the events of elements.
      ID_FUNCTION_SCRIPT_FIX = 'id-function-script-fix'.freeze

      ##
      # The ID of script element that contains the common functions of scripts.
      ID_SCRIPT_COMMON_FUNCTIONS = 'hatemile-common-functions'.freeze

      protected

      ##
      # Provide keyboard access for element, if it not has.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      # @return [void]
      def keyboard_access(element)
        return if element.has_attribute?('tabindex')

        tag = element.get_tag_name
        if (tag == 'A') && !element.has_attribute?('href')
          element.set_attribute('tabindex', '0')
        elsif (tag != 'A') &&
              (tag != 'INPUT') &&
              (tag != 'BUTTON') &&
              (tag != 'SELECT') &&
              (tag != 'TEXTAREA')
          element.set_attribute('tabindex', '0')
        end
      end

      ##
      # Include the scripts used by solutions.
      #
      # @return [void]
      def generate_main_scripts
        head = @parser.find('head').first_result
        unless head.nil?
          common_functions_script = @parser.find(
            "##{ID_SCRIPT_COMMON_FUNCTIONS}"
          ).first_result
          if common_functions_script.nil?
            common_functions_script = @parser.create_element('script')
            common_functions_script.set_attribute(
              'id',
              ID_SCRIPT_COMMON_FUNCTIONS
            )
            common_functions_script.set_attribute('type', 'text/javascript')
            common_functions_script.append_text(
              File.read(
                File.join(
                  File.dirname(File.dirname(File.dirname(__FILE__))),
                  'js',
                  'common.js'
                )
              )
            )
            head.prepend_element(common_functions_script)
          end

          if @parser.find("##{ID_SCRIPT_EVENT_LISTENER}").first_result.nil?
            script = @parser.create_element('script')
            script.set_attribute('id', ID_SCRIPT_EVENT_LISTENER)
            script.set_attribute('type', 'text/javascript')
            script.append_text(
              File.read(
                File.join(
                  File.dirname(File.dirname(File.dirname(__FILE__))),
                  'js',
                  'eventlistener.js'
                )
              )
            )
            common_functions_script.insert_after(script)
          end
        end
        local = @parser.find('body').first_result
        unless local.nil?
          @script_list = @parser.find("##{ID_LIST_IDS_SCRIPT}").first_result
          if @script_list.nil?
            @script_list = @parser.create_element('script')
            @script_list.set_attribute('id', ID_LIST_IDS_SCRIPT)
            @script_list.set_attribute('type', 'text/javascript')
            @script_list.append_text('var activeElements = [];')
            @script_list.append_text('var hoverElements = [];')
            @script_list.append_text('var dragElements = [];')
            @script_list.append_text('var dropElements = [];')
            local.append_element(@script_list)
          end
          if @parser.find("##{ID_FUNCTION_SCRIPT_FIX}").first_result.nil?
            script_function = @parser.create_element('script')
            script_function.set_attribute('id', ID_FUNCTION_SCRIPT_FIX)
            script_function.set_attribute('type', 'text/javascript')
            script_function.append_text(
              File.read(
                File.join(
                  File.dirname(File.dirname(File.dirname(__FILE__))),
                  'js',
                  'include.js'
                )
              )
            )
            local.append_element(script_function)
          end
        end
        @main_script_added = true
      end

      ##
      # Add a type of event in element.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      # @param event [String] The type of event.
      # @return [void]
      def add_event_in_element(element, event)
        generate_main_scripts unless @main_script_added

        return if @script_list.nil?

        @id_generator.generate_id(element)
        @script_list.append_text(
          "#{event}Elements.push('#{element.get_attribute('id')}');"
        )
      end

      public

      ##
      # Initializes a new object that manipulate the accessibility of the
      # Javascript events of elements of parser.
      #
      # @param parser [Hatemile::Util::Html::HTMLDOMParser] The HTML parser.
      def initialize(parser)
        Hatemile::Helper.require_not_nil(parser)
        Hatemile::Helper.require_valid_type(
          parser,
          Hatemile::Util::Html::HTMLDOMParser
        )

        @parser = parser
        @id_generator = Hatemile::Util::IDGenerator.new('event')
        @main_script_added = false
        @script_list = nil
      end

      ##
      # @see Hatemile::AccessibleEvent#make_accessible_drop_events
      def make_accessible_drop_events(element)
        element.set_attribute('aria-dropeffect', 'none')

        add_event_in_element(element, 'drop')
      end

      ##
      # @see Hatemile::AccessibleEvent#make_accessible_drag_events
      def make_accessible_drag_events(element)
        keyboard_access(element)

        element.set_attribute('aria-grabbed', 'false')

        add_event_in_element(element, 'drag')
      end

      ##
      # @see Hatemile::AccessibleEvent#make_accessible_all_drag_and_drop_events
      def make_accessible_all_drag_and_drop_events
        draggable_elements = @parser.find(
          '[ondrag],[ondragstart],[ondragend]'
        ).list_results
        draggable_elements.each do |draggable_element|
          next unless Hatemile::Util::CommonFunctions.is_valid_element?(
            draggable_element
          )

          make_accessible_drag_events(draggable_element)
        end
        droppable_elements = @parser.find(
          '[ondrop],[ondragenter],[ondragleave],[ondragover]'
        ).list_results
        droppable_elements.each do |droppable_element|
          next unless Hatemile::Util::CommonFunctions.is_valid_element?(
            droppable_element
          )

          make_accessible_drop_events(droppable_element)
        end
      end

      ##
      # @see Hatemile::AccessibleEvent#make_accessible_hover_events
      def make_accessible_hover_events(element)
        keyboard_access(element)

        add_event_in_element(element, 'hover')
      end

      ##
      # @see Hatemile::AccessibleEvent#make_accessible_all_hover_events
      def make_accessible_all_hover_events
        elements = @parser.find('[onmouseover],[onmouseout]').list_results
        elements.each do |element|
          if Hatemile::Util::CommonFunctions.is_valid_element?(element)
            make_accessible_hover_events(element)
          end
        end
      end

      ##
      # @see Hatemile::AccessibleEvent#make_accessible_click_events
      def make_accessible_click_events(element)
        keyboard_access(element)

        add_event_in_element(element, 'active')
      end

      ##
      # @see Hatemile::AccessibleEvent#make_accessible_all_click_events
      def make_accessible_all_click_events
        elements = @parser.find(
          '[onclick],[onmousedown],[onmouseup],[ondblclick]'
        ).list_results
        elements.each do |element|
          if Hatemile::Util::CommonFunctions.is_valid_element?(element)
            make_accessible_click_events(element)
          end
        end
      end
    end
  end
end
