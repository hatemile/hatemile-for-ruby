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
  'nokogiri_html_dom_parser'
)

##
# Test methods of Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMTextNode
# class.
class TestNokogiriHTMLDOMTextNode < Test::Unit::TestCase
  ##
  # Initialize common attributes used by test methods.
  def setup
    @html_code = "<!DOCTYPE html>
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
		        <tbody class=\"table-body\">
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
  end

  ##
  # Test get_text_content method.
  def test_get_text_content
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      @html_code
    )
    lis = html_parser.find('ol li').list_results

    lis.each_with_index do |li, index|
      assert_instance_of(
        Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMTextNode,
        li.get_first_node_child
      )
      assert_equal((index + 1).to_s, li.get_first_node_child.get_text_content)
    end
  end

  ##
  # Test set_text_content method.
  def test_set_text_content
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      @html_code
    )
    ins = html_parser.find('ins').first_result
    ins.get_first_node_child.set_text_content('Changed')

    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMTextNode,
      ins.get_first_node_child
    )
    assert_equal('Changed', ins.get_first_node_child.get_text_content)
  end

  ##
  # Test append_text method.
  def test_append_text
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      @html_code
    )
    ins = html_parser.find('ins').first_result
    ins.get_first_node_child.append_text(' and value')

    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMTextNode,
      ins.get_first_node_child
    )
    assert_equal('cell and value', ins.get_first_node_child.get_text_content)
  end

  ##
  # Test prepend_text method.
  def test_prepend_text
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      @html_code
    )
    ins = html_parser.find('ins').first_result
    ins.get_first_node_child.prepend_text('table and ')

    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMTextNode,
      ins.get_first_node_child
    )
    assert_equal('table and cell', ins.get_first_node_child.get_text_content)
  end

  ##
  # Test insert_before method.
  def test_insert_before
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      @html_code
    )
    link = html_parser.create_element('a')
    link.append_text('table and ')
    ins = html_parser.find('ins').first_result
    ins.get_first_node_child.insert_before(link)

    assert_equal(link, ins.get_first_node_child)
    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMTextNode,
      ins.get_last_node_child
    )
    assert_equal('table and cell', ins.get_text_content)
  end

  ##
  # Test insert_after method.
  def test_insert_after
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      @html_code
    )
    link = html_parser.create_element('a')
    link.append_text(' and value')
    ins = html_parser.find('ins').first_result
    ins.get_first_node_child.insert_after(link)

    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMTextNode,
      ins.get_first_node_child
    )
    assert_equal(link, ins.get_last_node_child)
    assert_equal('cell and value', ins.get_text_content)
  end

  ##
  # Test remove_node method.
  def test_remove_node
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      @html_code
    )
    ins = html_parser.find('ins').first_result
    ins.get_first_node_child.remove_node

    assert(!ins.has_children?)
  end

  ##
  # Test replace_node method.
  def test_replace_node
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      @html_code
    )
    ins = html_parser.find('ins').first_result
    strong = html_parser.find('strong').first_result
    ins.get_first_node_child.replace_node(strong.get_first_node_child)

    assert_equal('Strong text', ins.get_text_content)
    assert_equal('', strong.get_text_content)
  end

  ##
  # Test get_parent_element method.
  def test_get_parent_element
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      @html_code
    )
    ins = html_parser.find('ins').first_result

    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMTextNode,
      ins.get_first_node_child
    )
    assert_equal(ins, ins.get_first_node_child.get_parent_element)
  end

  ##
  # Test get_data and set_data methods.
  def test_get_set_data
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      @html_code
    )
    ins = html_parser.find('ins').first_result
    strong = html_parser.find('strong').first_result
    text_node = ins.get_first_node_child
    text_node.set_data(strong.get_first_node_child.get_data)
    text_node.append_text('!!!')

    assert_equal('Strong text!!!', text_node.get_text_content)
    assert_equal('Strong text!!!', strong.get_text_content)
    assert_equal('cell', ins.get_text_content)
  end
end
