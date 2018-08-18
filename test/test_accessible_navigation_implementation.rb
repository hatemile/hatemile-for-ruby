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

require 'rubygems'
require 'bundler/setup'
require 'test/unit'
require 'test/unit/assertions'

require File.join(
  File.dirname(File.dirname(__FILE__)),
  'lib',
  'hatemile',
  'implementation',
  'accessible_navigation_implementation'
)
require File.join(
  File.dirname(File.dirname(__FILE__)),
  'lib',
  'hatemile',
  'util',
  'configure'
)
require File.join(
  File.dirname(File.dirname(__FILE__)),
  'lib',
  'hatemile',
  'util',
  'html',
  'nokogiri',
  'nokogiri_html_dom_parser'
)

##
# Test methods of Hatemile::Implementation::AccessibleNavigationImplementation
# class.
class TestAccessibleNavigationImplementation < Test::Unit::TestCase
  ##
  # The name of attribute for not modify the elements.
  DATA_IGNORE = 'data-ignoreaccessibilityfix="true"'.freeze

  ##
  # The configuration of HaTeMiLe.
  CONFIGURE = Hatemile::Util::Configure.new.freeze

  ##
  # Test fix_shortcuts method with container of shorcuts not defined.
  def test_fix_shortcuts_container_not_defined
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new("
      <!DOCTYPE html>
      <html>
        <head>
			    <title>HaTeMiLe Tests</title>
			    <meta charset=\"UTF-8\" />
		    </head>
        <body>
          <a href=\"https://github.com/hatemile/\" accesskey=\"r\">
            HaTeMiLe in Github
          </a>
          <a href=\"https://hatemile.github.io\" title=\"Site\" accesskey=\"w\">
            Webpage
          </a>
          <a href=\"http://localhost/\" #{DATA_IGNORE} accesskey=\"i\">
            Ignore link
          </a>
          <form action=\"\">
            <label for=\"field1\">Field1</label>
            <input type=\"text\" id=\"field1\" accesskey=\"f\" /><br />
            <input type=\"submit\" value=\"Submit\" accesskey=\"s\" />
          </form>
        </body>
      </html>
    ")
    navigation =
      Hatemile::Implementation::AccessibleNavigationImplementation.new(
        html_parser,
        CONFIGURE
      )
    navigation.fix_shortcuts
    accesskey_r = html_parser.find('[accesskey="r"]').first_result
    accesskey_w = html_parser.find('[accesskey="w"]').first_result
    accesskey_f = html_parser.find('[accesskey="f"]').first_result
    accesskey_s = html_parser.find('[accesskey="s"]').first_result
    accesskey_i = html_parser.find('[accesskey="i"]').first_result
    reference_r = html_parser.find(
      '[data-shortcutdescriptionfor="R"]'
    ).first_result
    reference_w = html_parser.find(
      '[data-shortcutdescriptionfor="W"]'
    ).first_result
    reference_f = html_parser.find(
      '[data-shortcutdescriptionfor="F"]'
    ).first_result
    reference_s = html_parser.find(
      '[data-shortcutdescriptionfor="S"]'
    ).first_result
    reference_i = html_parser.find(
      '[data-shortcutdescriptionfor="I"]'
    ).first_result

    assert_not_nil(html_parser.find('#container-shortcuts').first_result)
    assert_equal('HaTeMiLe in Github', accesskey_r.get_attribute('title'))
    assert_equal('Site', accesskey_w.get_attribute('title'))
    assert_equal('Field1', accesskey_f.get_attribute('title'))
    assert_equal('Submit', accesskey_s.get_attribute('title'))
    assert(!accesskey_i.has_attribute?('title'))
    assert_equal('ALT + R: HaTeMiLe in Github', reference_r.get_text_content)
    assert_equal('ALT + W: Site', reference_w.get_text_content)
    assert_equal('ALT + F: Field1', reference_f.get_text_content)
    assert_equal('ALT + S: Submit', reference_s.get_text_content)
    assert_nil(reference_i)
  end

  ##
  # Test fix_shortcuts method with container of shortcuts defined.
  def test_fix_shortcuts_container_defined
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new("
      <!DOCTYPE html>
      <html>
        <head>
			    <title>HaTeMiLe Tests</title>
			    <meta charset=\"UTF-8\" />
		    </head>
        <body>
          <div id=\"container-shortcuts\"></div>
          <a href=\"https://github.com/hatemile/\" accesskey=\"r\">
            HaTeMiLe in Github
          </a>
          <a href=\"https://hatemile.github.io\" title=\"Site\" accesskey=\"w\">
            Webpage
          </a>
          <a href=\"http://localhost/\" #{DATA_IGNORE} accesskey=\"i\">
            Ignore link
          </a>
          <form action=\"\">
            <label for=\"field1\">Field1</label>
            <input type=\"text\" id=\"field1\" accesskey=\"f\" /><br />
            <input type=\"submit\" value=\"Submit\" accesskey=\"s\" />
          </form>
        </body>
      </html>
    ")
    navigation =
      Hatemile::Implementation::AccessibleNavigationImplementation.new(
        html_parser,
        CONFIGURE
      )
    navigation.fix_shortcuts
    accesskey_r = html_parser.find('[accesskey="r"]').first_result
    accesskey_w = html_parser.find('[accesskey="w"]').first_result
    accesskey_f = html_parser.find('[accesskey="f"]').first_result
    accesskey_s = html_parser.find('[accesskey="s"]').first_result
    accesskey_i = html_parser.find('[accesskey="i"]').first_result
    reference_r = html_parser.find(
      '#container-shortcuts [data-shortcutdescriptionfor="R"]'
    ).first_result
    reference_w = html_parser.find(
      '#container-shortcuts [data-shortcutdescriptionfor="W"]'
    ).first_result
    reference_f = html_parser.find(
      '#container-shortcuts [data-shortcutdescriptionfor="F"]'
    ).first_result
    reference_s = html_parser.find(
      '#container-shortcuts [data-shortcutdescriptionfor="S"]'
    ).first_result
    reference_i = html_parser.find(
      '#container-shortcuts [data-shortcutdescriptionfor="I"]'
    ).first_result

    assert_equal(
      'container-shortcuts',
      html_parser.find(
        'body'
      ).first_result.get_first_element_child.get_attribute('id')
    )
    assert_equal('HaTeMiLe in Github', accesskey_r.get_attribute('title'))
    assert_equal('Site', accesskey_w.get_attribute('title'))
    assert_equal('Field1', accesskey_f.get_attribute('title'))
    assert_equal('Submit', accesskey_s.get_attribute('title'))
    assert(!accesskey_i.has_attribute?('title'))
    assert_equal('ALT + R: HaTeMiLe in Github', reference_r.get_text_content)
    assert_equal('ALT + W: Site', reference_w.get_text_content)
    assert_equal('ALT + F: Field1', reference_f.get_text_content)
    assert_equal('ALT + S: Submit', reference_s.get_text_content)
    assert_nil(reference_i)
  end

  ##
  # Test fix_skippers method.
  def test_fix_skippers
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new("
      <!DOCTYPE html>
      <html>
        <head>
			    <title>HaTeMiLe Tests</title>
			    <meta charset=\"UTF-8\" />
		    </head>
        <body>
          <main>Main content</main>
          <div id=\"container-shortcuts\">Container of shortcuts</div>
          <div id=\"container-heading\" #{DATA_IGNORE}>
            Container of headings
          </div>
        </body>
      </html>
    ")
    navigation =
      Hatemile::Implementation::AccessibleNavigationImplementation.new(
        html_parser,
        CONFIGURE
      )
    navigation.fix_skippers
    body_children = html_parser.find('body').first_result.get_children_elements
    main_element = html_parser.find('main').first_result
    main_id = main_element.get_attribute('id')
    main_anchor = html_parser.find(
      "[data-anchorfor=\"#{main_id}\"]"
    ).first_result
    main_link = html_parser.find(
      "#container-skippers a[href=\"##{main_anchor.get_attribute('id')}\"]"
    ).first_result
    container_shortcuts = html_parser.find('#container-shortcuts').first_result
    container_shortcuts_anchor = html_parser.find(
      '[data-anchorfor="container-shortcuts"]'
    ).first_result
    container_shortcuts_id = container_shortcuts_anchor.get_attribute('id')
    container_shortcuts_link = html_parser.find(
      "#container-skippers a[href=\"##{container_shortcuts_id}\"]"
    ).first_result
    container_heading_anchor = html_parser.find(
      '[data-anchorfor="container-heading"]'
    ).first_result

    assert_not_nil(html_parser.find('#container-skippers').first_result)
    assert_not_nil(main_anchor)
    assert_not_nil(container_shortcuts_anchor)
    assert_nil(container_heading_anchor)
    assert_not_nil(main_link)
    assert_not_nil(container_shortcuts_link)
    assert_equal(
      body_children.index(main_element),
      body_children.index(main_anchor) + 1
    )
    assert_equal(
      body_children.index(container_shortcuts),
      body_children.index(container_shortcuts_anchor) + 1
    )
  end

  ##
  # Test fix_headings method.
  def test_fix_headings
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new("
      <!DOCTYPE html>
      <html>
        <head>
			    <title>HaTeMiLe Tests</title>
			    <meta charset=\"UTF-8\" />
		    </head>
        <body>
          <div>
            <h1><span>Heading 1</span></h1>
            <h2><span>Heading 1.2.1</span></h2>
            <div>
              <span></span>
              <div><h2><span>Heading 1.2.2</span></h2></div>
              <span></span>
            </div>
            <h3><span>Heading 1.2.2.3.1</span></h3>
            <h4><span>Heading 1.2.2.3.1.4.1</span></h4>
            <h2><span>Heading 1.2.3</span></h2>
            <h3><span>Heading 1.2.3.3.1</span></h3>
          </div>
        </body>
      </html>
    ")
    navigation =
      Hatemile::Implementation::AccessibleNavigationImplementation.new(
        html_parser,
        CONFIGURE
      )
    navigation.fix_headings
    container = html_parser.find('#container-heading').first_result
    headings = html_parser.find('h1, h2, h3, h4').list_results
    container_list = html_parser.find(container).find_descendants(
      '[data-headinglevel]'
    ).list_results
    links = html_parser.find('[data-headinglevel] a').list_results

    assert_not_nil(container)
    assert_equal(
      1,
      container_list.first.get_attribute('data-headinglevel').to_i
    )
    assert_equal(2, container_list[1].get_attribute('data-headinglevel').to_i)
    assert_equal(2, container_list[2].get_attribute('data-headinglevel').to_i)
    assert_equal(3, container_list[3].get_attribute('data-headinglevel').to_i)
    assert_equal(4, container_list[4].get_attribute('data-headinglevel').to_i)
    assert_equal(2, container_list[5].get_attribute('data-headinglevel').to_i)
    assert_equal(3, container_list[6].get_attribute('data-headinglevel').to_i)
    links.each do |link|
      anchor = html_parser.find(link.get_attribute('href')).first_result
      heading = html_parser.find(
        '#' + anchor.get_attribute('data-headinganchorfor')
      ).first_result
      children_elements = anchor.get_parent_element.get_children_elements

      assert_not_nil(anchor)
      assert(headings.include?(heading))
      assert_equal(
        children_elements.index(anchor),
        children_elements.index(heading) - 1
      )
    end
  end

  ##
  # Test fix_long_descriptions method.
  def test_fix_long_descriptions
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new("
      <!DOCTYPE html>
      <html>
        <head>
			    <title>HaTeMiLe Tests</title>
			    <meta charset=\"UTF-8\" />
		    </head>
        <body>
          <img src=\"i1.jpg\" alt=\"I1\" />
          <img src=\"i2.jpg\" alt=\"I2\" longdesc=\"i2.html\" />
          <img src=\"i3.jpg\" alt=\"\" longdesc=\"i3.html\" />
          <img src=\"i4.jpg\" longdesc=\"i4.html\" />
          <img src=\"i5.jpg\" alt=\"I5\" longdesc=\"i5.html\" #{DATA_IGNORE} />
        </body>
      </html>
    ")
    navigation =
      Hatemile::Implementation::AccessibleNavigationImplementation.new(
        html_parser,
        CONFIGURE
      )
    navigation.fix_long_descriptions
    long_description_links = html_parser.find(
      '[data-longdescriptionfor]'
    ).list_results
    image2_link = long_description_links.first
    image2 = html_parser.find(
      '#' + image2_link.get_attribute('data-longdescriptionfor')
    ).first_result
    image3_link = long_description_links[1]
    image3 = html_parser.find(
      '#' + image3_link.get_attribute('data-longdescriptionfor')
    ).first_result
    image4_link = long_description_links.last
    image4 = html_parser.find(
      '#' + image4_link.get_attribute('data-longdescriptionfor')
    ).first_result

    assert_equal(3, long_description_links.length)
    assert_equal('i2.jpg', image2.get_attribute('src'))
    assert_equal('i3.jpg', image3.get_attribute('src'))
    assert_equal('i4.jpg', image4.get_attribute('src'))
    assert_equal('I2 [d]', image2_link.get_text_content)
    assert_equal('[d]', image3_link.get_text_content)
    assert_equal('[d]', image4_link.get_text_content)
  end
end
