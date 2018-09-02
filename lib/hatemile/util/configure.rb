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

require 'yaml'
require File.join(File.dirname(File.dirname(__FILE__)), 'helper')

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
        Hatemile::Helper.require_valid_type(files_name, Array)
        Hatemile::Helper.require_valid_type(files_name, Array)

        if files_name.nil?
          pattern = File.join(
            File.dirname(File.dirname(File.dirname(__FILE__))),
            'locale',
            '*.yml'
          )
          files_name = Dir.glob(pattern)
        end
        @locales = locales
        @parameters = {}
        files_name.each do |file_name|
          @parameters = @parameters.merge(YAML.load_file(file_name))
        end
      end

      ##
      # Returns the parameters of configuration.
      #
      # @return [Hash] The parameters of configuration.
      def get_parameters
        clone_parameters = {}
        @locales.each do |locale|
          clone_parameters = @parameters[locale.to_s]['hatemile'].merge(
            clone_parameters
          )
        end
        clone_parameters
      end

      ##
      # Check that the configuration has an parameter.
      #
      # @param parameter [String] The parameter.
      # @return [Boolean] True if the configuration has the parameter or false
      #   if the configuration not has the parameter.
      def has_parameter?(parameter)
        @locales.each do |locale|
          return true if @parameters[locale.to_s]['hatemile'].key?(parameter)
        end
        false
      end

      ##
      # Returns the value of a parameter of configuration.
      #
      # @param parameter [String] The parameter.
      # @return [String] The value of the parameter.
      def get_parameter(parameter)
        @locales.each do |locale|
          next if @locales.last == locale

          value = @parameters[locale.to_s]['hatemile'].fetch(parameter, nil)
          return value unless value.nil?
        end
        @parameters[@locales.last.to_s]['hatemile'].fetch(parameter)
      end
    end
  end
end
