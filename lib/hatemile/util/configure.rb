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
      # @param file_name [String] The full path of file.
      def initialize(file_name = nil)
        @parameters = {}
        if file_name.nil?
          file_name = File.join(
            File.dirname(File.dirname(File.dirname(__FILE__))),
            'hatemile-configure.xml'
          )
        end
        document = REXML::Document.new(File.read(file_name))
        document.elements.each('parameters/parameter') do |parameter|
          if parameter.text.class != NilClass
            @parameters[parameter.attribute('name').value] = parameter.text
          else
            @parameters[parameter.attribute('name').value] = ''
          end
        end
      end

      ##
      # Returns the parameters of configuration.
      #
      # @return [Hash] The parameters of configuration.
      def get_parameters
        @parameters.clone
      end

      ##
      # Returns the value of a parameter of configuration.
      #
      # @param parameter [String] The parameter.
      # @return [String] The value of the parameter.
      def get_parameter(parameter)
        @parameters[parameter]
      end
    end
  end
end
