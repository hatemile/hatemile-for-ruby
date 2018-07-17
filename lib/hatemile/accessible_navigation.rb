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
  # The AccessibleNavigation interface fixes accessibility problems associated
  # with navigation.
  #
  # @abstract
  class AccessibleNavigation
    private_class_method :new

    ##
    # Display the shortcuts of element.
    #
    # @abstract
    # @param element [Hatemile::Util::Html::HTMLDOMElement] The element with
    #   shortcuts.
    # @return [void]
    def fix_shortcut(element)
      # Interface method
    end

    ##
    # Display the shortcuts of elements.
    #
    # @abstract
    # @return [void]
    def fix_shortcuts
      # Interface method
    end

    ##
    # Provide content skipper for element.
    #
    # @abstract
    # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
    # @return [void]
    def fix_skipper(element)
      # Interface method
    end

    ##
    # Provide content skippers.
    #
    # @abstract
    # @return [void]
    def fix_skippers
      # Interface method
    end

    ##
    # Provide a navigation by heading.
    #
    # @abstract
    # @param element [Hatemile::Util::Html::HTMLDOMElement] The heading element.
    # @return [void]
    def fix_heading(element)
      # Interface method
    end

    ##
    # Provide a navigation by headings.
    #
    # @abstract
    # @return [void]
    def fix_headings
      # Interface method
    end

    ##
    # Provide an alternative way to access the long description of element.
    #
    # @abstract
    # @param element [Hatemile::Util::Html::HTMLDOMElement] The element with
    #   long description.
    # @return [void]
    def fix_long_description(element)
      # Interface method
    end

    ##
    # Provide an alternative way to access the longs descriptions of elements.
    #
    # @abstract
    # @return [void]
    def fix_long_descriptions
      # Interface method
    end
  end
end
