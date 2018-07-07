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
  class AccessibleForm
    private_class_method :new

    ##
    # Display that the field is required.
    #
    # ---
    #
    # Parameters:
    #  1. Hatemile::Util::HTMLDOMElement +requiredField+ The required field.
    def fix_required_field(requiredField)
      # Interface method
    end

    ##
    # Display that the fields is required.
    def fix_required_fields
      # Interface method
    end

    ##
    # Display that the field have range.
    #
    # ---
    #
    # Parameters:
    #  1. Hatemile::Util::HTMLDOMElement +rangeField+ The range field.
    def fix_range_field(rangeField)
      # Interface method
    end

    ##
    # Display that the fields have range.
    def fix_range_fields
      # Interface method
    end

    ##
    # Display that the field have autocomplete.
    #
    # ---
    #
    # Parameters:
    #  1. Hatemile::Util::HTMLDOMElement +autoCompleteField+ The field with autocomplete.
    def fix_autocomplete_field(autoCompleteField)
      # Interface method
    end

    ##
    # Display that the fields have autocomplete.
    def fix_autocomplete_fields
      # Interface method
    end

    ##
    # Associate label with field.
    #
    # ---
    #
    # Parameters:
    #  1. Hatemile::Util::HTMLDOMElement +label+ The label.
    def fix_label(label)
      # Interface method
    end

    ##
    # Associate labels with fields.
    def fix_labels
      # Interface method
    end
  end
end
