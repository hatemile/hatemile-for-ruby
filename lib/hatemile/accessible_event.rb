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
  # The AccessibleEvent interface improve the accessibility, making elements
  # events available from a keyboard.
  #
  # @abstract
  class AccessibleEvent
    private_class_method :new

    ##
    # Make the drop events of element available from a keyboard.
    #
    # @abstract
    # @param element [Hatemile::Util::Html::HTMLDOMElement] The element with
    #   drop event.
    # @return [void]
    def make_accessible_drop_events(element)
      # Interface method
    end

    ##
    # Make the drag events of element available from a keyboard.
    #
    # @abstract
    # @param element [Hatemile::Util::Html::HTMLDOMElement] The element with
    #   drag event.
    # @return [void]
    def make_accessible_drag_events(element)
      # Interface method
    end

    ##
    # Make all Drag-and-Drop events of page available from a keyboard.
    #
    # @abstract
    # @return [void]
    def make_accessible_all_drag_and_drop_events
      # Interface method
    end

    ##
    # Make the hover events of element available from a keyboard.
    #
    # @abstract
    # @param element [Hatemile::Util::Html::HTMLDOMElement] The element with
    #   hover event.
    # @return [void]
    def make_accessible_hover_events(element)
      # Interface method
    end

    ##
    # Make all hover events of page available from a keyboard.
    #
    # @abstract
    # @return [void]
    def make_accessible_all_hover_events
      # Interface method
    end

    ##
    # Make the click events of element available from a keyboard.
    #
    # @abstract
    # @param element [Hatemile::Util::Html::HTMLDOMElement] The element with
    #   click events.
    # @return [void]
    def make_accessible_click_events(element)
      # Interface method
    end

    ##
    # Make all click events of page available from a keyboard.
    #
    # @abstract
    # @return [void]
    def make_accessible_all_click_events
      # Interface method
    end
  end
end
