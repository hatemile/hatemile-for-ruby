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
  # The AccessibleEvent interface fixes accessibility problems associated with
  # JavaScript events in elements.
  class AccessibleEvent
    private_class_method :new

    ##
    # Provide a solution for the element that has drop events.
    #
    # ---
    #
    # Parameters:
    #  1. Hatemile::Util::HTMLDOMElement +element+ The element with drop event.
    def fix_drop(element)
      # Interface method
    end

    ##
    # Provide a solution for the element that has drag events.
    #
    # ---
    #
    # Parameters:
    #  1. Hatemile::Util::HTMLDOMElement +element+ The element with drag event.
    def fix_drag(element)
      # Interface method
    end

    ##
    # Provide a solution for elements that has Drag-and-Drop events.
    def fix_drags_and_drops
      # Interface method
    end

    ##
    # Provide a solution for the element that has inaccessible hover events.
    #
    # ---
    #
    # Parameters:
    #  1. Hatemile::Util::HTMLDOMElement +element+ The element with hover event.
    def fix_hover(element)
      # Interface method
    end

    ##
    # Provide a solution for elements that has inaccessible hover events.
    def fix_hovers
      # Interface method
    end

    ##
    # Provide a solution for the element that has inaccessible active events.
    #
    # ---
    #
    # Parameters:
    #  1. Hatemile::Util::HTMLDOMElement +element+ The element with active event.
    def fix_active(element)
      # Interface method
    end

    ##
    # Provide a solution for elements that has inaccessible active events.
    def fix_actives
      # Interface method
    end
  end
end
