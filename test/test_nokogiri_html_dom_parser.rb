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

##
# Test methods of Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser
# class.
class TestNokogiriHTMLDOMParser < Test::Unit::TestCase
  ##
  # Initialize common attributes used by test methods.
  def setup
    @aside_text = '
      Exemple of <mark>aside</mark>.
      <!-- Comment -->
    '
    @aside_content = '<aside class="aside" data-attribute="custom_value">' \
                     "#{@aside_text}</aside>"
    meta_http = '<meta http-equiv="Content-Type" ' \
                'content="text/html; charset=UTF-8" />'
    @html_code = "<!DOCTYPE html>
      <html>
        <head>
          #{meta_http}
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
          #{@aside_content}
          <form>
            <label>
              Text:
              <input type=\"text\" name=\"number\" />
            </label>
          </form>
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
      </html>"
  end

  ##
  # Test find method.
  def test_find
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      @html_code
    )
    body = html_parser.find('body').first_result
    section = html_parser.find('section').first_result
    same_section = html_parser.find(section).first_result
    input = html_parser.find('[type="text"]').first_result
    li1 = html_parser.find('#li-1').first_result
    li3 = html_parser.find('ul li').last_result
    ins = html_parser.find('table tbody.table-body tr td ins').first_result
    inputs = html_parser.find('input[type="text"]').list_results
    lis = html_parser.find('ol li').list_results
    img = html_parser.find('img').first_result
    imgs = html_parser.find('img').list_results
    headings = []
    html_parser.find('h1, h2, h3, h4').list_results.each do |heading|
      headings.push(heading.get_text_content)
    end

    assert_equal(section, body.get_first_element_child)
    assert_equal(section, same_section)
    assert_equal('INPUT', input.get_tag_name)
    assert_equal('1', li1.get_text_content)
    assert_equal('3', li3.get_text_content)
    assert_equal('cell', ins.get_text_content)
    assert_equal([input], inputs)
    lis.each_with_index do |li, index|
      assert_equal('LI', li.get_tag_name)
      assert_equal((index + 1).to_s, li.get_text_content)
    end
    assert_nil(img)
    assert_equal(0, imgs.length)
    assert_equal(
      [
        'Heading 1',
        'Heading 1.2.1',
        'Heading 1.2.2',
        'Heading 1.2.2.3.1',
        'Heading 1.2.2.3.1.4.1',
        'Heading 1.2.3',
        'Heading 1.2.3.3.1'
      ],
      headings
    )
  end

  ##
  # Test find_children method.
  def test_find_children
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      @html_code
    )
    section = html_parser.find('body').find_children('section').last_result
    lis = html_parser.find('ol').find_children('li').list_results
    tbody1 = html_parser.find('body').find_children('.table-body').first_result
    tbody2 = html_parser.find('table').find_children('.table-body').first_result
    input = html_parser.find('form label').find_children(
      'input[type="text"]'
    ).first_result
    li1 = html_parser.find('ul').find_children('#li-1').first_result
    headings = []
    html_parser.find('h1, h2, h3, h4').find_children(
      'span'
    ).list_results.each do |heading|
      headings.push(heading.get_text_content)
    end
    pure_headings = html_parser.find('h1, h2, h3, h4').list_results
    headings2 = []
    html_parser.find(
      pure_headings
    ).find_children('span').list_results.each do |heading|
      headings2.push(heading.get_text_content)
    end
    pure_spans = html_parser.find('span').list_results
    headings3 = []
    html_parser.find(
      pure_headings
    ).find_children(pure_spans).list_results.each do |heading|
      headings3.push(heading.get_text_content)
    end

    assert_equal('SECTION', section.get_tag_name)
    lis.each_with_index do |li, index|
      assert_equal('LI', li.get_tag_name)
      assert_equal((index + 1).to_s, li.get_text_content)
    end
    assert_nil(tbody1)
    assert_not_nil(tbody2)
    assert_equal('INPUT', input.get_tag_name)
    assert_equal('1', li1.get_text_content)
    assert_equal(
      [
        'Heading 1',
        'Heading 1.2.1',
        'Heading 1.2.2',
        'Heading 1.2.2.3.1',
        'Heading 1.2.2.3.1.4.1',
        'Heading 1.2.3',
        'Heading 1.2.3.3.1'
      ],
      headings
    )
    assert_equal(
      [
        'Heading 1',
        'Heading 1.2.1',
        'Heading 1.2.2',
        'Heading 1.2.2.3.1',
        'Heading 1.2.2.3.1.4.1',
        'Heading 1.2.3',
        'Heading 1.2.3.3.1'
      ],
      headings2
    )
    assert_equal(
      [
        'Heading 1',
        'Heading 1.2.1',
        'Heading 1.2.2',
        'Heading 1.2.2.3.1',
        'Heading 1.2.2.3.1.4.1',
        'Heading 1.2.3',
        'Heading 1.2.3.3.1'
      ],
      headings3
    )
  end

  ##
  # Test find_descendants method.
  def test_find_descendants
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      @html_code
    )
    section = html_parser.find('body').find_descendants('section').last_result
    lis = html_parser.find('ol').find_descendants('li').list_results
    tbody1 = html_parser.find('body').find_descendants(
      '.table-body'
    ).first_result
    tbody2 = html_parser.find('table').find_descendants(
      '.table-body'
    ).first_result
    input = html_parser.find('form').find_descendants(
      'input[type="text"]'
    ).first_result
    li1 = html_parser.find('body').find_descendants('#li-1').first_result
    headings = []
    html_parser.find('h1, h2, h3, h4').find_descendants(
      'span'
    ).list_results.each do |heading|
      headings.push(heading.get_text_content)
    end
    pure_headings = html_parser.find('h1, h2, h3, h4').list_results
    headings2 = []
    html_parser.find(
      pure_headings
    ).find_descendants('span').list_results.each do |heading|
      headings2.push(heading.get_text_content)
    end
    pure_spans = html_parser.find('span').list_results
    headings3 = []
    html_parser.find(
      pure_headings
    ).find_descendants(pure_spans).list_results.each do |heading|
      headings3.push(heading.get_text_content)
    end

    assert_equal('SECTION', section.get_tag_name)
    lis.each_with_index do |li, index|
      assert_equal('LI', li.get_tag_name)
      assert_equal((index + 1).to_s, li.get_text_content)
    end
    assert_equal('TBODY', tbody1.get_tag_name)
    assert_equal(tbody1, tbody2)
    assert_equal('INPUT', input.get_tag_name)
    assert_equal('1', li1.get_text_content)
    assert_equal(
      [
        'Heading 1',
        'Heading 1.2.1',
        'Heading 1.2.2',
        'Heading 1.2.2.3.1',
        'Heading 1.2.2.3.1.4.1',
        'Heading 1.2.3',
        'Heading 1.2.3.3.1'
      ],
      headings
    )
    assert_equal(
      [
        'Heading 1',
        'Heading 1.2.1',
        'Heading 1.2.2',
        'Heading 1.2.2.3.1',
        'Heading 1.2.2.3.1.4.1',
        'Heading 1.2.3',
        'Heading 1.2.3.3.1'
      ],
      headings2
    )
    assert_equal(
      [
        'Heading 1',
        'Heading 1.2.1',
        'Heading 1.2.2',
        'Heading 1.2.2.3.1',
        'Heading 1.2.2.3.1.4.1',
        'Heading 1.2.3',
        'Heading 1.2.3.3.1'
      ],
      headings3
    )
  end

  ##
  # Test find_ancestors method.
  def test_find_ancestors
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      @html_code
    )
    body = html_parser.find('section').find_ancestors('body').last_result
    tbody1 = html_parser.find('ins').find_ancestors('.table-body').first_result
    tbody2 = html_parser.find('td').find_ancestors('.table-body').first_result
    input = html_parser.find('strong').find_ancestors(
      '[attribute="value"]'
    ).first_result
    headings = []
    html_parser.find('span').find_ancestors(
      'h1, h2, h3, h4'
    ).list_results.each do |heading|
      headings.push(heading.get_text_content)
    end
    pure_spans = html_parser.find('span').list_results
    headings2 = []
    html_parser.find(pure_spans).find_ancestors(
      'h1, h2, h3, h4'
    ).list_results.each do |heading|
      headings2.push(heading.get_text_content)
    end
    pure_headings = html_parser.find('h1, h2, h3, h4').list_results
    headings3 = []
    html_parser.find(pure_spans).find_ancestors(
      pure_headings
    ).list_results.each do |heading|
      headings3.push(heading.get_text_content)
    end

    assert_equal('BODY', body.get_tag_name)
    assert_equal('TBODY', tbody1.get_tag_name)
    assert_equal(tbody1, tbody2)
    assert_equal('SPAN', input.get_tag_name)
    assert_equal(
      [
        'Heading 1',
        'Heading 1.2.1',
        'Heading 1.2.2',
        'Heading 1.2.2.3.1',
        'Heading 1.2.2.3.1.4.1',
        'Heading 1.2.3',
        'Heading 1.2.3.3.1'
      ],
      headings
    )
    assert_equal(
      [
        'Heading 1',
        'Heading 1.2.1',
        'Heading 1.2.2',
        'Heading 1.2.2.3.1',
        'Heading 1.2.2.3.1.4.1',
        'Heading 1.2.3',
        'Heading 1.2.3.3.1'
      ],
      headings2
    )
    assert_equal(
      [
        'Heading 1',
        'Heading 1.2.1',
        'Heading 1.2.2',
        'Heading 1.2.2.3.1',
        'Heading 1.2.2.3.1.4.1',
        'Heading 1.2.3',
        'Heading 1.2.3.3.1'
      ],
      headings3
    )
  end

  ##
  # Test create_element method.
  def test_create_element
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      @html_code
    )
    img = html_parser.create_element('img')
    img.set_attribute('src', 'http://www.example.com/image.png')
    img.set_attribute('alt', 'Example')
    html_parser.find('body').first_result.append_element(img)
    same_img = html_parser.find('img').first_result

    assert_equal('IMG', img.get_tag_name)
    assert_instance_of(
      Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMElement,
      img
    )
    assert_equal(img, same_img)
  end

  ##
  # Test get_html method.
  def test_get_html
    html_parser = Hatemile::Util::Html::NokogiriLib::NokogiriHTMLDOMParser.new(
      @html_code
    )
    assert_equal(
      @html_code.freeze.gsub(/\s+/, ''),
      html_parser.get_html.gsub(/\s+/, '')
    )
  end
end
