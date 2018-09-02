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

require 'securerandom'
require File.join(File.dirname(File.dirname(__FILE__)), 'helper')

##
# The Hatemile module contains the interfaces with the acessibility solutions.
module Hatemile
  ##
  # The Hatemile::Util module contains the utilities of library.
  module Util
    ##
    # The IDGenerator class generate ids for
    # Hatemile::Util::Html::HTMLDOMElement.
    class IDGenerator
      ##
      # Initializes a new object that generate ids for elements.
      #
      # @param prefix_part [String] A part of prefix id.
      def initialize(prefix_part = nil)
        Hatemile::Helper.require_valid_type(prefix_part, String)

        @prefix_id = if prefix_part.nil?
                       "id-hatemile-#{SecureRandom.hex}-"
                     else
                       "id-hatemile-#{prefix_part}-#{SecureRandom.hex}-"
                     end
        @count = 0
      end

      ##
      # Generate a id for a element.
      #
      # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
      def generate_id(element)
        return if element.has_attribute?('id')

        element.set_attribute('id', "#{@prefix_id}#{@count}")
        @count += 1
      end
    end
  end
end
