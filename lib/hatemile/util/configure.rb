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
require 'i18n'

##
# The Hatemile module contains the interfaces with the acessibility solutions.
module Hatemile
  ##
  # The Hatemile::Util module contains the utilities of library.
  module Util
    ##
    # The Configure class contains the configuration of HaTeMiLe.
    class Configure
      ##
      # Initializes a new object that contains the configuration of HaTeMiLe.
      #
      # @param files_name [Array<String>] The path of files.
      # @param locales [Array<Symbol>] The locales.
      def initialize(files_name = nil, locales = [:'en-US'])
        if files_name.nil?
          pattern = File.join(
            File.dirname(File.dirname(File.dirname(__FILE__))),
            'locale',
            '*.yml'
          )
          files_name = Dir.glob(pattern)
        end
        I18n.load_path += files_name
        @options = []
        locales.each do |locale|
          option = {}
          option[:locale] = locale
          option[:scope] = :hatemile
          @options.push(option)
        end
      end

      ##
      # Returns the parameters of configuration.
      #
      # @return [Hash] The parameters of configuration.
      def get_parameters
        symbol_parameters = {}
        @options.each do |option|
          option_root_scope = {}
          option_root_scope[:locale] = option[:locale]
          symbol_parameters = I18n.t!(:hatemile, option_root_scope).merge(
            symbol_parameters
          )
        end
        parameters = {}
        symbol_parameters.each do |key, value|
          parameters[key.to_s] = value
        end
        parameters
      end

      ##
      # Check that the configuration has an parameter.
      #
      # @param parameter [String] The name of parameter.
      # @return [Boolean] True if the configuration has the parameter or false
      #   if the configuration not has the parameter.
      def has_parameter?(parameter)
        @options.each do |option|
          option_default = option.clone
          option_default[:default] = nil

          return true unless I18n.t(parameter, option_default).nil?
        end
        false
      end

      ##
      # Returns the value of a parameter of configuration.
      #
      # @param parameter [String] The name of parameter.
      # @return [String] The value of the parameter.
      def get_parameter(parameter)
        @options.each do |option|
          next if @options.last == option

          option_default = option.clone
          option_default[:default] = nil

          value = I18n.t(parameter, option_default)
          return value unless value.nil?
        end
        I18n.t!(parameter, @options.last)
      end
    end
  end
end
