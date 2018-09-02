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

require File.join(
  File.dirname(File.dirname(__FILE__)),
  'accessible_css'
)
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
require File.join(
  File.dirname(File.dirname(__FILE__)),
  'util',
  'html',
  'nokogiri',
  'nokogiri_html_dom_text_node'
)

##
# The Hatemile module contains the interfaces with the acessibility solutions.
module Hatemile
  ##
  # The Hatemile::Implementation module contains the official implementation of
  # interfaces solutions.
  module Implementation
    ##
    # The AccessibleCSSImplementation class is official implementation of
    # AccessibleCSS.
    class AccessibleCSSImplementation < AccessibleCSS
      public_class_method :new

      ##
      # The name of attribute for identify isolator elements.
      DATA_ISOLATOR_ELEMENT = 'data-auxiliarspan'.freeze

      ##
      # The name of attribute for identify the element created or modified to
      # support speak property.
      DATA_SPEAK = 'data-cssspeak'.freeze

      ##
      # The name of attribute for identify the element created or modified to
      # support speak-as property.
      DATA_SPEAK_AS = 'data-cssspeakas'.freeze

      ##
      # The valid element tags for inherit the speak and speak-as properties.
      VALID_INHERIT_TAGS = %w[
        SPAN A RT DFN ABBR Q CITE EM TIME VAR SAMP I B SUB SUP SMALL STRONG
        MARK RUBY INS DEL KBD BDO CODE P FIGCAPTION FIGURE PRE DIV OL UL LI
        BLOCKQUOTE DL DT DD FIELDSET LEGEND LABEL FORM BODY ASIDE ADDRESS H1 H2
        H3 H4 H5 H6 SECTION HEADER NAV ARTICLE FOOTER HGROUP CAPTION SUMMARY
        DETAILS TABLE TR TD TH TBODY THEAD TFOOT
      ].freeze

      ##
      # The valid element tags for speak and speak-as properties.
      VALID_TAGS = %w[
        SPAN A RT DFN ABBR Q CITE EM TIME VAR SAMP I B SUB SUP SMALL STRONG MARK
        RUBY INS DEL KBD BDO CODE P FIGCAPTION FIGURE PRE DIV LI BLOCKQUOTE DT
        DD FIELDSET LEGEND LABEL FORM BODY ASIDE ADDRESS H1 H2 H3 H4 H5 H6
        SECTION HEADER NAV ARTICLE FOOTER CAPTION SUMMARY DETAILS TD TH
      ].freeze

      protected

      ##
      # The operation method of _speak_as method for spell-out.
      #
      # @param content [String] The text content of element.
      # @param index [Integer] The index of pattern in text content of element.
      # @param children [Array<Hatemile::Util::Html::HTMLDOMElement>] The
      #   children of element.
      # @return [Array<Hatemile::Util::Html::HTMLDOMElement>] The new children
      #   of element.
      def operation_speak_as_spell_out(content, index, children)
        children.push(
          create_content_element(content[0..index], 'spell-out')
        )

        children.push(create_aural_content_element(' ', 'spell-out'))

        children
      end

      ##
      # The operation method of _speak_as method for literal-punctuation.
      #
      # @param content [String] The text content of element.
      # @param index [Integer] The index of pattern in text content of element.
      # @param children [Array<Hatemile::Util::Html::HTMLDOMElement>] The
      #   children of element.
      # @return [Array<Hatemile::Util::Html::HTMLDOMElement>] The new children
      #   of element.
      def operation_speak_as_literal_punctuation(content, index, children)
        data_property_value = 'literal-punctuation'
        unless index.zero?
          children.push(
            create_content_element(content[0..(index - 1)], data_property_value)
          )
        end
        children.push(
          create_aural_content_element(
            " #{get_description_of_symbol(content[index..index])} ",
            data_property_value
          )
        )

        children.push(
          create_visual_content_element(
            content[index..index],
            data_property_value
          )
        )

        children
      end

      ##
      # The operation method of _speak_as method for no-punctuation.
      #
      # @param content [String] The text content of element.
      # @param index [Integer] The index of pattern in text content of element.
      # @param children [Array<Hatemile::Util::Html::HTMLDOMElement>] The
      #   children of element.
      # @return [Array<Hatemile::Util::Html::HTMLDOMElement>] The new children
      #   of element.
      def operation_speak_as_no_punctuation(content, index, children)
        unless index.zero?
          children.push(
            create_content_element(content[0..(index - 1)], 'no-punctuation')
          )
        end
        children.push(
          create_visual_content_element(
            content[index..index],
            'no-punctuation'
          )
        )

        children
      end

      ##
      # The operation method of _speak_as method for digits.
      #
      # @param content [String] The text content of element.
      # @param index [Integer] The index of pattern in text content of element.
      # @param children [Array<Hatemile::Util::Html::HTMLDOMElement>] The
      #   children of element.
      # @return [Array<Hatemile::Util::Html::HTMLDOMElement>] The new children
      #   of element.
      def operation_speak_as_digits(content, index, children)
        data_property_value = 'digits'
        unless index.zero?
          children.push(
            create_content_element(content[0..(index - 1)], data_property_value)
          )
        end
        children.push(create_aural_content_element(' ', data_property_value))

        children.push(
          create_content_element(
            content[index..index],
            data_property_value
          )
        )

        children
      end

      ##
      # Load the symbols with configuration.
      #
      # @param file_name [String] The file path of symbol configuration.
      def set_symbols(file_name)
        @symbols = []
        if file_name.nil?
          file_name = File.join(
            File.dirname(File.dirname(File.dirname(__FILE__))),
            'symbols.xml'
          )
        end
        document = REXML::Document.new(File.read(file_name))
        document.elements.each('symbols/symbol') do |symbol_xml|
          symbol = {}
          symbol[:symbol] = symbol_xml.attribute('symbol').value
          symbol[:description] = @configure.get_parameter(
            symbol_xml.attribute('description').value
          )
          @symbols.push(symbol)
        end
      end

      ##
      # Returns the description of symbol.
      #
      # @param symbol [String] The symbol.
      # @return [String] The description of symbol.
      def get_description_of_symbol(symbol)
        @symbols.each do |dict_symbol|
          return dict_symbol[:description] if dict_symbol[:symbol] == symbol
        end
        nil
      end

      ##
      # Returns the regular expression to search all symbols.
      #
      # @return [String] The regular expression to search all symbols.
      def get_regular_expression_of_symbols
        regular_expression = nil
        @symbols.each do |symbol|
          formated_symbol = Regexp.escape(symbol[:symbol])
          regular_expression = if regular_expression.nil?
                                 "(#{formated_symbol})"
                               else
                                 "#{regular_expression}|(#{formated_symbol})"
                               end
        end
        Regexp.new(regular_expression)
      end

      ##
      # Check that the children of element can be manipulated to apply the CSS
      # properties.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      # @return [Boolean] True if the children of element can be manipulated to
      #   apply the CSS properties or false if the children of element cannot be
      #   manipulated to apply the CSS properties.
      def is_valid_inherit_element?(element)
        VALID_INHERIT_TAGS.include?(element.get_tag_name) &&
          Hatemile::Util::CommonFunctions.is_valid_element?(element)
      end

      ##
      # Check that the element can be manipulated to apply the CSS properties.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      # @return [Boolean] True if the element can be manipulated to apply the
      #   CSS properties or False if the element cannot be manipulated to apply
      #   the CSS properties.
      def is_valid_element?(element)
        VALID_TAGS.include?(element.get_tag_name)
      end

      ##
      # Isolate text nodes of element nodes.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def isolate_text_node(element)
        unless element.has_children_elements? && is_valid_element?(element)
          return
        end

        element.get_children.each do |child_node|
          next unless child_node.is_a?(Hatemile::Util::Html::HTMLDOMTextNode)

          span = @html_parser.create_element('span')
          span.set_attribute(DATA_ISOLATOR_ELEMENT, 'true')
          span.append_text(child_node.get_text_content)

          child_node.replace_node(span)
        end
        element.get_children_elements.each do |child|
          isolate_text_node(child)
        end
      end

      ##
      # Replace the element by own text content.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def replace_element_by_own_content(element)
        if element.has_children_elements?
          element.get_children_elements.each do |child|
            element.insert_before(child)
          end
          element.remove_node
        elsif element.has_children?
          element.replace_node(element.get_first_node_child)
        end
      end

      ##
      # Visit and execute a operation in element and descendants.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      # @param operation [Method] The operation to be executed.
      def visit(element, operation)
        return unless is_valid_inherit_element?(element)

        if element.has_children_elements?
          element.get_children_elements.each do |child|
            visit(child, operation)
          end
        elsif is_valid_element?(element)
          operation.call(element)
        end
      end

      ##
      # Create a element to show the content.
      #
      # @param content [String] The text content of element.
      # @param data_property_value [String] The value of custom attribute used
      #   to identify the fix.
      # @return [Hatemile::Util::Html::HTMLDOMElement] The element to show the
      #   content.
      def create_content_element(content, data_property_value)
        content_element = @html_parser.create_element('span')
        content_element.set_attribute(DATA_ISOLATOR_ELEMENT, 'true')
        content_element.set_attribute(DATA_SPEAK_AS, data_property_value)
        content_element.append_text(content)
        content_element
      end

      ##
      # Create a element to show the content, only to aural displays.
      #
      # @param content [String] The text content of element.
      # @param data_property_value [String] The value of custom attribute used
      #   to identify the fix.
      # @return [Hatemile::Util::Html::HTMLDOMElement] The element to show the
      #   content.
      def create_aural_content_element(content, data_property_value)
        content_element = create_content_element(content, data_property_value)
        content_element.set_attribute('unselectable', 'on')
        content_element.set_attribute('class', 'screen-reader-only')
        content_element
      end

      ##
      # Create a element to show the content, only to visual displays.
      #
      # @param content [String] The text content of element.
      # @param data_property_value [String] The value of custom attribute used
      #   to identify the fix.
      # @return [Hatemile::Util::Html::HTMLDOMElement] The element to show the
      #   content.
      def create_visual_content_element(content, data_property_value)
        content_element = create_content_element(content, data_property_value)
        content_element.set_attribute('aria-hidden', 'true')
        content_element.set_attribute('role', 'presentation')
        content_element
      end

      ##
      # Speak the content of element only.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def speak_normal(element)
        return unless element.has_attribute?(DATA_SPEAK)

        if element.get_attribute(DATA_SPEAK) == 'none' &&
           !element.has_attribute?(DATA_ISOLATOR_ELEMENT)
          element.remove_attribute('role')
          element.remove_attribute('aria-hidden')
          element.remove_attribute(DATA_SPEAK)
        else
          replace_element_by_own_content(element)
        end
      end

      ##
      # Speak the content of element and descendants.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def speak_normal_inherit(element)
        visit(element, method(:speak_normal))

        element.normalize
      end

      ##
      # No speak any content of element only.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def speak_none(element)
        element.set_attribute('role', 'presentation')
        element.set_attribute('aria-hidden', 'true')
        element.set_attribute(DATA_SPEAK, 'none')
      end

      ##
      # No speak any content of element and descendants.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def speak_none_inherit(element)
        isolate_text_node(element)

        visit(element, method(:speak_none))
      end

      ##
      # Execute a operation by regular expression for element only.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      # @param regular_expression [Regexp] The regular expression.
      # @param data_property_value [String] The value of custom attribute used
      #   to identify the fix.
      # @param operation [Method] The operation to be executed.
      def speak_as(element, regular_expression, data_property_value, operation)
        children = []
        content = element.get_text_content
        until content.empty?
          index = content.index(regular_expression)

          break if index.nil?

          children = operation.call(content, index, children)

          new_index = index + 1
          content = content[new_index..-1]
        end

        return if children.empty?

        unless content.empty?
          children.push(create_content_element(content, data_property_value))
        end
        element.get_first_node_child.remove_node while element.has_children?
        children.each do |child|
          element.append_element(child)
        end
      end

      ##
      # Revert changes of a speak_as method for element and descendants.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      # @param data_property_value [String] The value of custom attribute used
      #   to identify the fix.
      def reverse_speak_as(element, data_property_value)
        data_property = "[#{DATA_SPEAK_AS}=\"#{data_property_value}\"]"

        auxiliar_elements = @html_parser.find(element).find_descendants(
          "#{data_property}[unselectable=\"on\"]"
        ).list_results
        auxiliar_elements.each(&:remove_node)

        content_elements = @html_parser.find(element).find_descendants(
          "#{data_property}[#{DATA_ISOLATOR_ELEMENT}=\"true\"],
          #{data_property}[aria-hidden]"
        ).list_results
        content_elements.each do |content_element|
          replace_element_by_own_content(content_element)
        end
        element.normalize
      end

      ##
      # Use the default speak configuration of user agent for element and
      # descendants.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def speak_as_normal(element)
        reverse_speak_as(element, 'spell-out')
        reverse_speak_as(element, 'literal-punctuation')
        reverse_speak_as(element, 'no-punctuation')
        reverse_speak_as(element, 'digits')
      end

      ##
      # Speak one letter at a time for each word for element only.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def speak_as_spell_out(element)
        speak_as(
          element,
          /[a-zA-Z]/,
          'spell-out',
          method(:operation_speak_as_spell_out)
        )
      end

      ##
      # Speak one letter at a time for each word for elements and descendants.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def speak_as_spell_out_inherit(element)
        reverse_speak_as(element, 'spell-out')

        isolate_text_node(element)

        visit(element, method(:speak_as_spell_out))
      end

      ##
      # Speak the punctuation for elements only.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def speak_as_literal_punctuation(element)
        speak_as(
          element,
          get_regular_expression_of_symbols,
          'literal-punctuation',
          method(:operation_speak_as_literal_punctuation)
        )
      end

      ##
      # Speak the punctuation for elements and descendants.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def speak_as_literal_punctuation_inherit(element)
        reverse_speak_as(element, 'literal-punctuation')
        reverse_speak_as(element, 'no-punctuation')

        isolate_text_node(element)

        visit(element, method(:speak_as_literal_punctuation))
      end

      ##
      # No speak the punctuation for element only.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def speak_as_no_punctuation(element)
        escape_punctuation = Regexp.escape('!"#$%&\'()*+,-./:;<=>?@[]^_`{|}~\\')
        speak_as(
          element,
          Regexp.new("[#{escape_punctuation}]"),
          'no-punctuation',
          method(:operation_speak_as_no_punctuation)
        )
      end

      ##
      # No speak the punctuation for element and descendants.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def speak_as_no_punctuation_inherit(element)
        reverse_speak_as(element, 'literal-punctuation')
        reverse_speak_as(element, 'no-punctuation')

        isolate_text_node(element)

        visit(element, method(:speak_as_no_punctuation))
      end

      ##
      # Speak the digit at a time for each number for element only.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def speak_as_digits(element)
        speak_as(element, /[0-9]/, 'digits', method(:operation_speak_as_digits))
      end

      ##
      # Speak the digit at a time for each number for element and descendants.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def speak_as_digits_inherit(element)
        reverse_speak_as(element, 'digits')

        isolate_text_node(element)

        visit(element, method(:speak_as_digits))
      end

      ##
      # Speaks the numbers for element and descendants as a word number.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def speak_as_continuous_inherit(element)
        reverse_speak_as(element, 'digits')
      end

      ##
      # The cells headers will be spoken for every data cell for element and
      # descendants.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def speak_header_always_inherit(element)
        speak_header_once_inherit(element)

        cell_elements = @html_parser.find(element).find_descendants(
          'td[headers],th[headers]'
        ).list_results
        accessible_display = AccessibleDisplayImplementation(
          @html_parser,
          @configure
        )
        cell_elements.each do |cell_element|
          accessible_display.display_cell_header(cell_element)
        end
      end

      ##
      # The cells headers will be spoken one time for element and descendants.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def speak_header_once_inherit(element)
        header_elements = @html_parser.find(element).find_descendants(
          "[#{DATA_ATTRIBUTE_HEADERS_OF}]"
        ).list_results
        header_elements.each(&:remove_node)
      end

      ##
      # Provide the CSS features of speaking and speech properties in element.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      # @param rule [Hatemile::Util::Css::StyleSheetRule] The stylesheet rule.
      def provide_speak_properties_with_rule(element, rule)
        if rule.has_property?('speak')
          declarations = rule.get_declarations('speak')
          declarations.each do |declaration|
            property_value = declaration.get_value
            if property_value == 'none'
              speak_none_inherit(element)
            elsif property_value == 'normal'
              speak_normal_inherit(element)
            elsif property_value == 'spell-out'
              speak_as_spell_out_inherit(element)
            end
          end
        end
        if rule.has_property?('speak-as')
          declarations = rule.get_declarations('speak-as')
          declarations.each do |declaration|
            speak_as_values = declaration.get_values
            speak_as_normal(element)
            speak_as_values.each do |speak_as_value|
              if speak_as_value == 'spell-out'
                speak_as_spell_out_inherit(element)
              elsif speak_as_value == 'literal-punctuation'
                speak_as_literal_punctuation_inherit(element)
              elsif speak_as_value == 'no-punctuation'
                speak_as_no_punctuation_inherit(element)
              elsif speak_as_value == 'digits'
                speak_as_digits_inherit(element)
              end
            end
          end
        end
        if rule.has_property?('speak-punctuation')
          declarations = rule.get_declarations('speak-punctuation')
          declarations.each do |declaration|
            property_value = declaration.get_value
            if property_value == 'code'
              speak_as_literal_punctuation_inherit(element)
            elsif property_value == 'none'
              speak_as_no_punctuation_inherit(element)
            end
          end
        end
        if rule.has_property?('speak-numeral')
          declarations = rule.get_declarations('speak-numeral')
          declarations.each do |declaration|
            property_value = declaration.get_value
            if property_value == 'digits'
              speak_as_digits_inherit(element)
            elsif property_value == 'continuous'
              speak_as_continuous_inherit(element)
            end
          end
        end

        return unless rule.has_property?('speak-header')

        declarations = rule.get_declarations('speak-header')
        declarations.each do |declaration|
          property_value = declaration.get_value
          if property_value == 'always'
            speak_header_always_inherit(element)
          elsif property_value == 'once'
            speak_header_once_inherit(element)
          end
        end
      end

      public

      ##
      # Initializes a new object that improve the accessibility of associations
      # of parser.
      #
      # @param html_parser [Hatemile::Util::Html::HTMLDOMParser] The HTML
      #   parser.
      # @param css_parser [Hatemile::Util::Css::StyleSheetParser] The CSS
      #   parser.
      # @param configure [Hatemile::Util::Configure] The configuration of
      #   HaTeMiLe.
      # @param symbol_file_name [String] The file path of symbol configuration.
      def initialize(html_parser, css_parser, configure, symbol_file_name = nil)
        @html_parser = html_parser
        @css_parser = css_parser
        @configure = configure
        @id_generator = Hatemile::Util::IDGenerator.new('css')
        set_symbols(symbol_file_name)
      end

      ##
      # @see Hatemile::AccessibleCSS#provide_speak_properties
      def provide_speak_properties(element)
        rules = @css_parser.get_rules(
          %w[speak speak-punctuation speak-numeral speak-header speak-as]
        )
        rules.each do |rule|
          speak_elements = @html_parser.find(rule.get_selector).list_results
          if speak_elements.include?(element)
            provide_speak_properties_with_rule(element, rule)
          end
        end
      end

      ##
      # @see Hatemile::AccessibleCSS#provide_all_speak_properties
      def provide_all_speak_properties
        selector = nil
        rules = @css_parser.get_rules(
          %w[speak speak-punctuation speak-numeral speak-header speak-as]
        )
        rules.each do |rule|
          selector = if selector.nil?
                       rule.get_selector
                     else
                       "#{selector},#{rule.get_selector}"
                     end
        end

        return if selector.nil?

        @html_parser.find(selector).list_results.each do |element|
          if Hatemile::Util::CommonFunctions.is_valid_element?(element)
            provide_speak_properties(element)
          end
        end
      end
    end
  end
end
