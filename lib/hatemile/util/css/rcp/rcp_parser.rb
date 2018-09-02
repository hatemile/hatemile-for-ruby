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

require 'css_parser'
require 'uri'
require File.join(
  File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))),
  'helper'
)
require File.join(File.dirname(File.dirname(__FILE__)), 'style_sheet_parser')
require File.join(File.dirname(__FILE__), 'rcp_rule')

##
# The Hatemile module contains the interfaces with the acessibility solutions.
module Hatemile
  ##
  # The Hatemile::Util module contains the utilities of library.
  module Util
    ##
    # The Hatemile::Util::Css module contains the interfaces of CSS handles.
    module Css
      ##
      # The Hatemile::Util::Css::Rcp module contains the implementation of CSS
      # handles for Ruby CSS Parser library.
      module Rcp
        ##
        # The RCPParser class is official implementation of
        # Hatemile::Util::Css::StyleSheetParser for Ruby CSS Parser.
        class RCPParser < Hatemile::Util::Css::StyleSheetParser
          include CssParser
          public_class_method :new

          protected

          ##
          # Load the stylesheets of page.
          #
          # @param html_parser [Hatemile::Util::Html::HTMLDOMParser] The HTML
          #   parser.
          # @param current_url [String] The current URL of page.
          def load_stylesheets(html_parser, current_url)
            elements = html_parser.find(
              'style,link[rel="stylesheet"]'
            ).list_results
            elements.each do |element|
              if element.get_tag_name == 'STYLE'
                @css_parser.load_string!(element.get_text_content)
              else
                @css_parser.load_uri!(
                  URI.join(current_url, element.get_attribute('href'))
                )
              end
            end
          end

          public

          ##
          # Initializes a new object that encapsulate the Ruby CSS Parser.
          #
          # @param css_or_hp [String, Hatemile::Util::Html::HTMLDOMParser] The
          #   HTML parser or CSS code of page.
          # @param current_url [String] The current URL of page.
          def initialize(css_or_hp, current_url = nil)
            Hatemile::Helper.require_not_nil(css_or_hp)
            Hatemile::Helper.require_valid_type(
              css_or_hp,
              Hatemile::Util::Html::HTMLDOMParser,
              String
            )
            Hatemile::Helper.require_valid_type(current_url, String)

            @css_parser = CssParser::Parser.new
            if css_or_hp.is_a?(String)
              @css_parser.load_string!(css_or_hp)
            else
              load_stylesheets(css_or_hp, current_url)
            end
          end

          ##
          # @see Hatemile::Util::Css::StyleSheetParser#get_rules
          def get_rules(properties = nil)
            rules = []
            @css_parser.each_rule_set do |rule|
              auxiliar_rule = RCPRule.new(rule)

              if properties.nil?
                rules.push(auxiliar_rule)
                next
              end

              properties.each do |property_name|
                if auxiliar_rule.has_property?(property_name)
                  rules.push(auxiliar_rule)
                  break
                end
              end
            end
            rules
          end
        end
      end
    end
  end
end
