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

##
# The Hatemile module contains the interfaces with the acessibility solutions.
module Hatemile
  ##
  # Helper methods of HaTeMiLe for Ruby.
  module Helper
    ##
    # Error class for nil arguments.
    class NotNilError < StandardError; end

    ##
    # Checks that the specified objects references is not nil and throws a
    # TypeError if it is.
    #
    # @param values [Array<Object>] The objects.
    # @return [void]
    def self.require_not_nil(*values)
      values.each do |value|
        if value.nil?
          raise NotNilError.new('The value of parameter not be nil.')
        end
      end
    end

    ##
    # Checks that the specified object reference is instance of classes and
    # TypeError
    #
    # @param value [Object] The object.
    # @param classes [Array<Class>] The classes.
    # @return [void]
    def self.require_valid_type(value, *classes)
      return if value.nil?

      valid = false
      classes.each do |auxiliar_class|
        if value.is_a?(auxiliar_class)
          valid = true
          break
        end
      end

      raise TypeError.new('Wrong type of argument.') unless valid
    end
  end
end
