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
    # ---
    #
    # Parameters:
    #  1. Hatemile::Util::HTMLDOMElement +element+ The element with shortcuts.
    def fixShortcut(element)
      # Interface method
    end

    ##
    # Display the shortcuts of elements.
    def fixShortcuts
      # Interface method
    end

    ##
    # Provide content skipper for element.
    #
    # ---
    #
    # Parameters:
    #  1. Hatemile::Util::HTMLDOMElement +element+ The element.
    #  2. Hatemile::Util::Skipper +skipper+ The skipper.
    def fixSkipper(element, skipper)
      # Interface method
    end

    ##
    # Provide content skippers.
    def fixSkippers
      # Interface method
    end

    ##
    # Provide a navigation by heading.
    #
    # ---
    #
    # Parameters:
    #  1. Hatemile::Util::HTMLDOMElement +element+ The heading element.
    def fixHeading(element)
      # Interface method
    end

    ##
    # Provide a navigation by headings.
    def fixHeadings
      # Interface method
    end
  end
end
