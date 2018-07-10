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

module Hatemile
  ##
  # The AccessibleForm interface fixes accessibility problems associated with
  # forms.
  #
  # @abstract
  class AccessibleForm
    private_class_method :new

    ##
    # Display that the field is required.
    #
    # @abstract
    # @param required_field [Hatemile::Util::HTMLDOMElement] The required field.
    # @return [void]
    def fix_required_field(required_field)
      # Interface method
    end

    ##
    # Display that the fields is required.
    #
    # @abstract
    # @return [void]
    def fix_required_fields
      # Interface method
    end

    ##
    # Display that the field have range.
    #
    # @abstract
    # @param range_field [Hatemile::Util::HTMLDOMElement] The range field.
    # @return [void]
    def fix_range_field(range_field)
      # Interface method
    end

    ##
    # Display that the fields have range.
    #
    # @abstract
    # @return [void]
    def fix_range_fields
      # Interface method
    end

    ##
    # Display that the field have autocomplete.
    #
    # @abstract
    # @param autocomplete_field [Hatemile::Util::HTMLDOMElement] The field with
    #   autocomplete.
    # @return [void]
    def fix_autocomplete_field(autocomplete_field)
      # Interface method
    end

    ##
    # Display that the fields have autocomplete.
    #
    # @abstract
    # @return [void]
    def fix_autocomplete_fields
      # Interface method
    end

    ##
    # Associate label with field.
    #
    # @abstract
    # @param label [Hatemile::Util::HTMLDOMElement] The label.
    # @return [void]
    def fix_label(label)
      # Interface method
    end

    ##
    # Associate labels with fields.
    #
    # @abstract
    # @return [void]
    def fix_labels
      # Interface method
    end
  end
end
