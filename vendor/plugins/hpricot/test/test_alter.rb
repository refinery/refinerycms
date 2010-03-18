# -*- coding: utf-8 -*-
#!/usr/bin/env ruby

require 'test/unit'
require 'hpricot'
require 'load_files'

class TestAlter < Test::Unit::TestCase
  def setup
    @basic = Hpricot.parse(TestFiles::BASIC)
  end

  def test_before
    test0 = "<link rel='stylesheet' href='test0.css' />"
    @basic.at("link").before(test0)
    assert_equal 'test0.css', @basic.at("link").attributes['href']
  end

  def test_after
    test_inf = "<link rel='stylesheet' href='test_inf.css' />"
    @basic.search("link")[-1].after(test_inf)
    assert_equal 'test_inf.css', @basic.search("link")[-1].attributes['href']
  end

  def test_wrap
    ohmy = (@basic/"p.ohmy").wrap("<div id='wrapper'></div>")
    assert_equal 'wrapper', ohmy[0].parent['id']
    assert_equal 'ohmy', Hpricot(@basic.to_html).at("#wrapper").children[0]['class']
  end

  def test_add_class
    first_p = (@basic/"p:first").add_class("testing123")
    assert first_p[0].get_attribute("class").split(" ").include?("testing123")
    assert (Hpricot(@basic.to_html)/"p:first")[0].attributes["class"].split(" ").include?("testing123")
    assert !(Hpricot(@basic.to_html)/"p:gt(0)")[0].attributes["class"].split(" ").include?("testing123")
  end

  def test_change_attributes
    all_ps = (@basic/"p").attr("title", "Some Title & Etc…")
    all_as = (@basic/"a").attr("href", "http://my_new_href.com")
    all_lb = (@basic/"link").attr("href") { |e| e.name }
    assert_changed(@basic, "p", all_ps) {|p| p.raw_attributes["title"] == "Some Title &amp; Etc&#8230;"}
    assert_changed(@basic, "a", all_as) {|a| a.attributes["href"] == "http://my_new_href.com"}
    assert_changed(@basic, "link", all_lb) {|a| a.attributes["href"] == "link" }
  end

  def test_change_attributes2
    all_as = (@basic%"a").attributes["href"] = "http://my_new_href.com"
    all_ps = (@basic%"p").attributes["title"] = "Some Title & Etc…"
    assert_equal (@basic%"a").raw_attributes["href"], "http://my_new_href.com"
    assert_equal (@basic%"p").raw_attributes["title"], "Some Title &amp; Etc&#8230;"
    assert_equal (@basic%"p").attributes["title"], "Some Title & Etc…"
  end

  def test_remove_attr
    all_rl = (@basic/"link").remove_attr("href")
    assert_changed(@basic, "link", all_rl) { |link| link['href'].nil? }
  end

  def test_remove_class
    all_c1 = (@basic/"p[@class*='last']").remove_class("last")
    assert_changed(@basic, "p[@class*='last']", all_c1) { |p| p['class'] == 'final' }
  end

  def test_remove_all_classes
    all_c2 = (@basic/"p[@class]").remove_class
    assert_changed(@basic, "p[@class]", all_c2) { |p| p['class'].nil? }
  end

  def test_xml_casing
    doc = Hpricot.XML("<root><wildCat>text</wildCat></root>")
    (doc/:root/:wildCat).after("<beanPole>gravity</beanPole>")
    assert_equal doc.to_s, "<root><wildCat>text</wildCat><beanPole>gravity</beanPole></root>"

    frag = Hpricot.XML do
      b { i "A bit of HTML" }
    end
    (frag/:b).after("<beanPole>gravity</beanPole>")
    assert_equal frag.to_s, "<b><i>A bit of HTML</i></b><beanPole>gravity</beanPole>"
  end

  def test_reparent_empty_nodes
    doc = Hpricot("<div/>")
    doc.root.inner_html = "foo"
    assert_equal doc.root.inner_html, "foo"
    doc.root.inner_html = ""
    assert_equal doc.root.inner_html, ""
    doc.root.swap { b "test" }
    assert_equal doc.root.inner_html, "test"
  end

  def assert_changed original, selector, set, &block
    assert set.all?(&block)
    assert Hpricot(original.to_html).search(selector).all?(&block)
  end
end
