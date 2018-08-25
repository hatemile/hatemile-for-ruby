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
  # The AccessibleForm interface improve the accessibility of forms.
  #
  # @abstract
  class AccessibleForm
    private_class_method :new

    ##
    # Mark that the field is required.
    #
    # @abstract
    # @param required_field [Hatemile::Util::Html::HTMLDOMElement] The required
    #   field.
    # @return [void]
    def mark_required_field(required_field)
      # Interface method
    end

    ##
    # Mark that the fields is required.
    #
    # @abstract
    # @return [void]
    def mark_all_required_fields
      # Interface method
    end

    ##
    # Mark that the field have range.
    #
    # @abstract
    # @param range_field [Hatemile::Util::Html::HTMLDOMElement] The range field.
    # @return [void]
    def mark_range_field(range_field)
      # Interface method
    end

    ##
    # Mark that the fields have range.
    #
    # @abstract
    # @return [void]
    def mark_all_range_fields
      # Interface method
    end

    ##
    # Mark that the field have autocomplete.
    #
    # @abstract
    # @param autocomplete_field [Hatemile::Util::Html::HTMLDOMElement] The field
    #   with autocomplete.
    # @return [void]
    def mark_autocomplete_field(autocomplete_field)
      # Interface method
    end

    ##
    # Mark that the fields have autocomplete.
    #
    # @abstract
    # @return [void]
    def mark_all_autocomplete_fields
      # Interface method
    end

    ##
    # Mark a solution to display that this field is invalid.
    #
    # @abstract
    # @param field [Hatemile::Util::Html::HTMLDOMElement] The field.
    # @return [void]
    def mark_invalid_field(field)
      # Interface method
    end

    ##
    # Mark a solution to display that a fields are invalid.
    #
    # @abstract
    # @return [void]
    def mark_all_invalid_fields
      # Interface method
    end
  end
end
