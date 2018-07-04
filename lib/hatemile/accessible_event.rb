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
    def fixDrop(element)
    end

    ##
    # Provide a solution for the element that has drag events.
    #
    # ---
    #
    # Parameters:
    #  1. Hatemile::Util::HTMLDOMElement +element+ The element with drag event.
    def fixDrag(element)
    end

    ##
    # Provide a solution for elements that has Drag-and-Drop events.
    def fixDragsandDrops()
    end

    ##
    # Provide a solution for the element that has inaccessible hover events.
    #
    # ---
    #
    # Parameters:
    #  1. Hatemile::Util::HTMLDOMElement +element+ The element with hover event.
    def fixHover(element)
    end

    ##
    # Provide a solution for elements that has inaccessible hover events.
    def fixHovers()
    end

    ##
    # Provide a solution for the element that has inaccessible active events.
    #
    # ---
    #
    # Parameters:
    #  1. Hatemile::Util::HTMLDOMElement +element+ The element with active event.
    def fixActive(element)
    end

    ##
    # Provide a solution for elements that has inaccessible active events.
    def fixActives()
    end
  end
end
