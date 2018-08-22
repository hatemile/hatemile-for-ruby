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
  # The AccessibleNavigation interface improve the accessibility of navigation.
  #
  # @abstract
  class AccessibleNavigation
    private_class_method :new

    ##
    # Provide a content skipper for element.
    #
    # @abstract
    # @param element [Hatemile::Util::Html::HTMLDOMElement] The element.
    # @return [void]
    def provide_navigation_by_skipper(element)
      # Interface method
    end

    ##
    # Provide navigation by content skippers.
    #
    # @abstract
    # @return [void]
    def provide_navigation_by_all_skippers
      # Interface method
    end

    ##
    # Provide navigation by heading.
    #
    # @abstract
    # @param heading [Hatemile::Util::Html::HTMLDOMElement] The heading element.
    # @return [void]
    def provide_navigation_by_heading(heading)
      # Interface method
    end

    ##
    # Provide navigation by headings of page.
    #
    # @abstract
    # @return [void]
    def provide_navigation_by_all_headings
      # Interface method
    end

    ##
    # Provide an alternative way to access the long description of element.
    #
    # @abstract
    # @param image [Hatemile::Util::Html::HTMLDOMElement] The image with long
    #   description.
    # @return [void]
    def provide_navigation_to_long_description(image)
      # Interface method
    end

    ##
    # Provide an alternative way to access the longs descriptions of all
    # elements of page.
    #
    # @abstract
    # @return [void]
    def provide_navigation_to_all_long_descriptions
      # Interface method
    end
  end
end
