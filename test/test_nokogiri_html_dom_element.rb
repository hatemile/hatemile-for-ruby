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

require File.join(
  File.dirname(File.dirname(__FILE__)),
  'lib',
  'hatemile',
  'util',
  'html',
  'nokogiri',
  'nokogiri_html_dom_element'
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
require File.join(
  File.dirname(File.dirname(__FILE__)),
  'lib',
  'hatemile',
  'util',
  'html',
  'nokogiri',
  'nokogiri_html_dom_text_node'
)

##
# Test methods of Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMElement
# class.
class TestNokogiriHTMLDOMElement < Test::Unit::TestCase
  ##
  # The content of aside element of parser.
  ASIDE_TEXT = '
      Exemple of <mark>aside</mark>.
      <!-- Comment -->
  '.freeze

  ##
  # The aside element of parser.
  ASIDE_CONTENT =
    '<aside class="aside" data-attribute="custom_value">' \
    "#{ASIDE_TEXT}</aside>".freeze

  ##
  # Initialize common attributes used by test methods.
  def setup
    @html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      "<!DOCTYPE html>
	    <html>
		    <head>
			    <title>HaTeMiLe Tests</title>
			    <meta charset=\"UTF-8\" />
		    </head>
		    <body>
		      <section>
		        <header></header>
		        <article>
		        \n
		        </article>
		        <footer><!-- Footer --></footer>
		      </section>
		      <span attribute=\"value\" data-attribute=\"custom_value\">
		        <!-- Comment -->
		        Text node
		        <strong>Strong text</strong>
		        <hr />
		      </span>
		      <div></div>
		      <p>
		        <del>Deleted text</del>
		      </p>
		      <table>
		        <thead><tr>
		          <th>Table header</th>
		        </tr></thead>
		        <tbody>
		          <tr>
		            <td>Table <ins>cell</ins></td>
		          </tr>
		        </tbody>
		        <tfoot><!-- Table footer --></tfoot>
		      </table>
		      <ul>
		        <li id=\"li-1\">1</li>
		        <li id=\"li-3\">3</li>
		      </ul>
		      <ol>
		        <li>1</li>
		        <li>2</li>
		        <li>3</li>
		        <li>4</li>
		        <li>5</li>
		      </ol>
		      #{ASIDE_CONTENT}
		      <form>
		        <label>
		          Text:
		          <input type=\"text\" name=\"number\" />
		        </label>
		      </form>
		      <h1></h1>
		      <h2></h2>
		    </body>
		  </html>"
    )
  end

  ##
  # Test == method
  def test_equals
    body = @html_parser.find('body').first_result
    section = @html_parser.find('section').first_result
    header = @html_parser.find('header').first_result

    assert_equal(body, @html_parser.find('body').first_result)
    assert_equal(section, body.get_first_element_child)
    assert_equal(body, section.get_parent_element)
    assert_not_equal(body, section)
    assert_not_equal(body, @html_parser.create_element('body'))
    assert_not_equal(header, @html_parser.create_element('header'))
  end

  ##
  # Test get_tag_name method.
  def test_get_tag_name
    span = @html_parser.find('span').first_result

    assert_equal('SPAN', span.get_tag_name)
  end

  ##
  # Test get_attribute method.
  def test_get_attribute
    span = @html_parser.find('span').first_result

    assert_equal('value', span.get_attribute('attribute'))
    assert_equal('custom_value', span.get_attribute('data-attribute'))
    assert_nil(span.get_attribute('newattribute'))
    assert_nil(span.get_attribute('data-newattribute'))
  end

  ##
  # Test set_attribute method.
  def test_set_attribute
    span = @html_parser.find('span').first_result

    span.set_attribute('newattribute', 'new_value')
    span.set_attribute('data-newattribute', 'custom_new_value')
    span.set_attribute('attribute', 'other_value')
    span.set_attribute('data-attribute', 'custom_other_value')

    assert_equal('new_value', span.get_attribute('newattribute'))
    assert_equal('custom_new_value', span.get_attribute('data-newattribute'))
    assert_equal('other_value', span.get_attribute('attribute'))
    assert_equal('custom_other_value', span.get_attribute('data-attribute'))
    assert_nil(span.get_attribute('invalidattribute'))
    assert_nil(span.get_attribute('data-invalidattribute'))
  end

  ##
  # Test has_attribute method.
  def test_has_attribute?
    span = @html_parser.find('span').first_result

    assert(!span.has_attribute?('newattribute'))
    assert(!span.has_attribute?('data-newattribute'))
    assert(span.has_attribute?('attribute'))
    assert(span.has_attribute?('data-attribute'))

    span.set_attribute('newattribute', 'new_value')
    span.set_attribute('data-newattribute', 'custom_new_value')
    span.set_attribute('attribute', 'other_value')
    span.set_attribute('data-attribute', 'custom_other_value')

    assert(span.has_attribute?('newattribute'))
    assert(span.has_attribute?('data-newattribute'))
    assert(span.has_attribute?('attribute'))
    assert(span.has_attribute?('data-attribute'))
  end

  ##
  # Test remove_attribute method.
  def test_remove_attribute
    span = @html_parser.find('span').first_result

    assert(span.has_attribute?('attribute'))
    assert(span.has_attribute?('data-attribute'))

    span.remove_attribute('attribute')
    span.remove_attribute('data-attribute')

    assert(!span.has_attribute?('attribute'))
    assert(!span.has_attribute?('data-attribute'))
  end

  ##
  # Test has_attributes? method.
  def test_has_attributes
    span = @html_parser.find('span').first_result

    assert(span.has_attributes?)

    span.remove_attribute('attribute')

    assert(span.has_attributes?)

    span.remove_attribute('data-attribute')

    assert(!span.has_attributes?)
  end

  ##
  # Test get_children_elements method.
  def test_get_children_elements
    span = @html_parser.find('span').first_result
    strong = @html_parser.find('strong').first_result

    assert_equal(2, span.get_children_elements.length)
    assert_equal(strong, span.get_children_elements.first)
    assert_equal('HR', span.get_children_elements.last.get_tag_name)
    assert_equal([], strong.get_children_elements)
  end

  ##
  # Test get_children method.
  def test_get_children
    span = @html_parser.find('span').first_result
    hr = @html_parser.find('hr').first_result

    assert_equal(6, span.get_children.length)
    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMTextNode,
      span.get_children.first
    )
    assert_equal(
      '',
      span.get_children.first.get_text_content.strip.gsub(/[\n\r\t]+/, '')
    )
    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMTextNode,
      span.get_children[1]
    )
    assert_equal(
      'Text node',
      span.get_children[1].get_text_content.strip.gsub(/[\n\r\t]+/, '')
    )
    assert_equal('STRONG', span.get_children[2].get_tag_name)
    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMTextNode,
      span.get_children[3]
    )
    assert_equal(
      '',
      span.get_children[3].get_text_content.strip.gsub(/[\n\r\t]+/, '')
    )
    assert_equal('HR', span.get_children[4].get_tag_name)
    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMTextNode,
      span.get_children.last
    )
    assert_equal(
      '',
      span.get_children.last.get_text_content.strip.gsub(/[\n\r\t]+/, '')
    )
    assert_equal([], hr.get_children)
  end

  ##
  # Test append_element method.
  def test_append_element
    paragraph = @html_parser.find('p').first_result
    del = @html_parser.find('del').first_result
    i = @html_parser.create_element('i')

    paragraph.append_element(@html_parser.create_element('em'))

    assert_equal('EM', paragraph.get_children_elements.last.get_tag_name)
    assert_equal('EM', paragraph.get_children.last.get_tag_name)
    assert_equal([], del.get_children_elements)

    del.append_element(i)

    assert_equal([i], del.get_children_elements)
  end

  ##
  # Test prepend_element method.
  def test_prepend_element
    paragraph = @html_parser.find('p').first_result
    mark = @html_parser.create_element('mark')
    i = @html_parser.create_element('i')

    paragraph.prepend_element(mark)

    assert_equal(mark, paragraph.get_children_elements.first)
    assert_equal(mark, paragraph.get_children.first)
    assert_equal('DEL', paragraph.get_children_elements.last.get_tag_name)
    assert_equal([], mark.get_children_elements)

    mark.append_element(i)

    assert_equal([i], mark.get_children_elements)
  end

  ##
  # Test normalize method.
  def test_normalize
    div = @html_parser.find('div').first_result

    div.append_text('Text 1').append_text('Text 2').append_text('Text 3')
    div.normalize

    assert_equal(1, div.get_children.length)
  end

  ##
  # Test has_children_elements? method.
  def test_has_children_elements
    section = @html_parser.find('section').first_result
    header = @html_parser.find('header').first_result
    article = @html_parser.find('article').first_result
    footer = @html_parser.find('footer').first_result

    assert(section.has_children_elements?)
    assert(!header.has_children_elements?)
    assert(!article.has_children_elements?)
    assert(!footer.has_children_elements?)
  end

  ##
  # Test has_children? method.
  def test_has_children
    table = @html_parser.find('table').first_result
    thead = @html_parser.find('thead').first_result
    th = @html_parser.find('th').first_result
    td = @html_parser.find('td').first_result
    tfoot = @html_parser.find('tfoot').first_result

    assert(table.has_children?)
    assert(thead.has_children?)
    assert(th.has_children?)
    assert(td.has_children?)
    assert(!tfoot.has_children?)
  end

  ##
  # Test get_inner_html method.
  def test_get_inner_html
    aside = @html_parser.find('aside').first_result

    assert_equal(ASIDE_TEXT, aside.get_inner_html)
  end

  ##
  # Test get_outer_html method.
  def test_get_outer_html
    aside = @html_parser.find('aside').first_result

    assert_equal(ASIDE_CONTENT, aside.get_outer_html)
  end

  ##
  # Test get_first_element_child method.
  def test_get_first_element_child
    section = @html_parser.find('section').first_result
    header = @html_parser.find('header').first_result
    article = @html_parser.find('article').first_result
    footer = @html_parser.find('footer').first_result

    assert_equal(header, section.get_first_element_child)
    assert_nil(header.get_first_element_child)
    assert_nil(article.get_first_element_child)
    assert_nil(footer.get_first_element_child)
  end

  ##
  # Test get_last_element_child method.
  def test_get_last_element_child
    section = @html_parser.find('section').first_result
    header = @html_parser.find('header').first_result
    article = @html_parser.find('article').first_result
    footer = @html_parser.find('footer').first_result

    assert_equal(footer, section.get_last_element_child)
    assert_nil(header.get_last_element_child)
    assert_nil(article.get_last_element_child)
    assert_nil(footer.get_last_element_child)
  end

  ##
  # Test get_first_node_child method.
  def test_get_first_node_child
    thead = @html_parser.find('thead').first_result
    th = @html_parser.find('th').first_result
    td = @html_parser.find('td').first_result
    tfoot = @html_parser.find('tfoot').first_result

    assert_equal('TR', thead.get_first_node_child.get_tag_name)
    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMTextNode,
      th.get_first_node_child
    )
    assert_equal('Table header', th.get_first_node_child.get_text_content)
    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMTextNode,
      th.get_first_node_child
    )
    assert_equal('Table', td.get_first_node_child.get_text_content.strip)
    assert_nil(tfoot.get_first_node_child)
  end

  ##
  # Test get_last_node_child method.
  def test_get_last_node_child
    thead = @html_parser.find('thead').first_result
    th = @html_parser.find('th').first_result
    td = @html_parser.find('td').first_result
    tfoot = @html_parser.find('tfoot').first_result

    assert_equal('TR', thead.get_last_node_child.get_tag_name)
    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMTextNode,
      th.get_last_node_child
    )
    assert_equal('Table header', th.get_last_node_child.get_text_content)
    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMTextNode,
      th.get_last_node_child
    )
    assert_equal('INS', td.get_last_node_child.get_tag_name)
    assert_nil(tfoot.get_last_node_child)
  end

  ##
  # Test clone_element method.
  def test_clone_element
    tbody = @html_parser.find('tbody').first_result

    cloned_tbody = tbody.clone

    assert_equal(tbody.get_outer_html, cloned_tbody.get_outer_html)
  end

  ##
  # Test get_text_content method.
  def test_get_text_content
    th = @html_parser.find('th').first_result
    td = @html_parser.find('td').first_result
    tfoot = @html_parser.find('tfoot').first_result

    assert_equal('Table header', th.get_text_content)
    assert_equal('Table cell', td.get_text_content)
    assert_equal('', tfoot.get_text_content)
  end

  ##
  # Test insert_before method.
  def test_insert_before
    list_element = @html_parser.find('ul').first_result
    item_element = @html_parser.find('#li-3').first_result

    new_item_element = @html_parser.create_element('li')
    new_item_element.set_attribute('id', 'li-2')
    new_item_element.append_text('2')
    item_element.insert_before(new_item_element)

    assert_equal(
      'li-1',
      list_element.get_first_element_child.get_attribute('id')
    )
    assert_equal(
      'li-2',
      list_element.get_children_elements[1].get_attribute('id')
    )
  end

  ##
  # Test insert_after method.
  def test_insert_after
    list_element = @html_parser.find('ul').first_result
    item_element = @html_parser.find('#li-3').first_result

    new_item_element = @html_parser.create_element('li')
    new_item_element.set_attribute('id', 'li-4')
    new_item_element.append_text('4')
    item_element.insert_after(new_item_element)

    assert_equal(
      'li-1',
      list_element.get_first_element_child.get_attribute('id')
    )
    assert_equal(
      'li-4',
      list_element.get_last_element_child.get_attribute('id')
    )
  end

  ##
  # Test remove_node method.
  def test_remove_node
    list_element = @html_parser.find('ol').first_result

    assert_equal(5, list_element.get_children_elements.length)

    list_element.get_first_element_child.remove_node
    list_element.get_last_element_child.remove_node

    assert_equal(3, list_element.get_children_elements.length)

    list_element.remove_node

    assert_nil(@html_parser.find('ol').first_result)
    assert_nil(@html_parser.find('ol li').first_result)
  end

  ##
  # Test replace_node method.
  def test_replace_node
    input = @html_parser.find('input[name=number]').first_result

    textarea = @html_parser.create_element('textarea')
    input.replace_node(textarea)

    assert_nil(@html_parser.find('input[name=number]').first_result)
    assert_not_nil(@html_parser.find('textarea').first_result)
  end

  ##
  # Test append_text method.
  def test_append_text
    h1 = @html_parser.find('h1').first_result

    assert_not_nil(h1.append_text('Example'))
    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMElement,
      h1.append_text(' of ')
    )

    h1.append_text('append ').append_text('text.')

    assert_equal('Example of append text.', h1.get_text_content)
  end

  ##
  # Test prepend_text method.
  def test_prepend_text
    h2 = @html_parser.find('h2').first_result

    assert_not_nil(h2.prepend_text(' text.'))
    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMElement,
      h2.prepend_text('prepend')
    )

    h2.prepend_text(' of ').prepend_text('Example')

    assert_equal('Example of prepend text.', h2.get_text_content)
  end

  ##
  # Test get_parent_element method.
  def test_get_parent_element
    body = @html_parser.find('body').first_result
    section = @html_parser.find('section').first_result
    header = @html_parser.find('header').first_result
    article = @html_parser.find('article').first_result

    assert_equal(section, header.get_parent_element)
    assert_equal(section, article.get_parent_element)
    assert_equal(body, section.get_parent_element)
  end

  ##
  # Test get_set_data method.
  def test_get_set_data
    body = @html_parser.find('body').first_result
    section = @html_parser.find('section').first_result

    section.set_data(body.get_data)
    section.set_attribute('class', 'body')
    assert_equal('body', body.get_attribute('class'))
  end
end
