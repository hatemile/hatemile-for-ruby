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
  File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))),
  'helper'
)
require File.join(File.dirname(File.dirname(__FILE__)), 'style_sheet_rule')
require File.join(File.dirname(__FILE__), 'rcp_declaration')

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
        # The RCPRule class is official implementation of
        # Hatemile::Util::Css::StyleSheetRule for Ruby CSS Parser.
        class RCPRule < Hatemile::Util::Css::StyleSheetRule
          public_class_method :new

          ##
          # Initializes a new object that encapsulate the Ruby CSS Parser rule.
          #
          # @param rule [CssParser::RuleSet] The Ruby CSS Parser rule.
          def initialize(rule)
            Hatemile::Helper.require_not_nil(rule)
            Hatemile::Helper.require_valid_type(rule, CssParser::RuleSet)

            @rule = rule
          end

          ##
          # @see Hatemile::Util::Css::StyleSheetRule#has_property?
          def has_property?(property_name)
            @rule.each_declaration do |property, _value, _important|
              return true if property == property_name
            end
            false
          end

          ##
          # @see Hatemile::Util::Css::StyleSheetRule#has_declarations?
          def has_declarations?
            true
          end

          ##
          # @see Hatemile::Util::Css::StyleSheetRule#get_declarations
          def get_declarations(property_name)
            declarations = []
            @rule.each_declaration do |property, value, _important|
              if property == property_name
                declarations.push(RCPDeclaration.new(property, value))
              end
            end
            declarations
          end

          ##
          # @see Hatemile::Util::Css::StyleSheetRule#get_selector
          def get_selector
            @rule.selectors.join(', ')
          end
        end
      end
    end
  end
end
