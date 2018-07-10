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
  # The AccessibleNavigation interface fixes accessibility problems associated
  # with navigation.
  class AccessibleNavigation
    private_class_method :new

    ##
    # Display the shortcuts of element.
    #
    # @param element [Hatemile::Util::HTMLDOMElement] The element with
    #   shortcuts.
    # @return [void]
    def fix_shortcut(element)
      # Interface method
    end

    ##
    # Display the shortcuts of elements.
    #
    # @return [void]
    def fix_shortcuts
      # Interface method
    end

    ##
    # Provide content skipper for element.
    #
    # @param element [Hatemile::Util::HTMLDOMElement] The element.
    # @param skipper [Hatemile::Util::Skipper] The skipper.
    # @return [void]
    def fix_skipper(element, skipper)
      # Interface method
    end

    ##
    # Provide content skippers.
    #
    # @return [void]
    def fix_skippers
      # Interface method
    end

    ##
    # Provide a navigation by heading.
    #
    # @param element [Hatemile::Util::HTMLDOMElement] The heading element.
    # @return [void]
    def fix_heading(element)
      # Interface method
    end

    ##
    # Provide a navigation by headings.
    #
    # @return [void]
    def fix_headings
      # Interface method
    end
  end
end
