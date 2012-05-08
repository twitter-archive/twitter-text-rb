require 'test/unit'
require 'yaml'
require 'nokogiri'

# Ruby 1.8 encoding check
major, minor, patch = RUBY_VERSION.split('.')
if major.to_i == 1 && minor.to_i < 9
  $KCODE='u'
end

require File.expand_path('../../lib/twitter-text', __FILE__)

class ConformanceTest < Test::Unit::TestCase
  include Twitter::Extractor
  include Twitter::Autolink
  include Twitter::HitHighlighter
  include Twitter::Validation

  private

  %w(description expected text hits).each do |key|
    define_method key.to_sym do
      @test_info[key]
    end
  end

  def assert_equal_without_attribute_order(expected, actual, failure_message = nil)
    assert_block(build_message(failure_message, "<?> expected but was\n<?>", expected, actual)) do
      equal_nodes?(Nokogiri::HTML(expected).root, Nokogiri::HTML(actual).root)
    end
  end

  def equal_nodes?(expected, actual)
    return false unless expected.name == actual.name
    return false unless ordered_attributes(expected) == ordered_attributes(actual)

    expected.children.each_with_index do |child, index|
      return false unless equal_nodes?(child, actual.children[index])
    end

    true
  end

  def ordered_attributes(element)
    element.attribute_nodes.map{|attr| [attr.name, attr.value]}.sort
  end

  CONFORMANCE_DIR = ENV['CONFORMANCE_DIR'] || File.expand_path("../twitter-text-conformance", __FILE__)

  def self.def_conformance_test(file, test_type, &block)
    yaml = YAML.load_file(File.join(CONFORMANCE_DIR, file))
    raise  "No such test suite: #{test_type.to_s}" unless yaml["tests"][test_type.to_s]

    yaml["tests"][test_type.to_s].each do |test_info|
      name = :"test_#{test_type}_#{test_info['description']}"
      define_method name do
        @test_info = test_info
        instance_eval(&block)
      end
    end
  end

  public

  # Extractor Conformance
  def_conformance_test("extract.yml", :replies) do
    assert_equal expected, extract_reply_screen_name(text), description
  end

  def_conformance_test("extract.yml", :mentions) do
    assert_equal expected, extract_mentioned_screen_names(text), description
  end

  def_conformance_test("extract.yml", :mentions_with_indices) do
    e = expected.map{|elem| elem.inject({}){|h, (k,v)| h[k.to_sym] = v; h} }
    assert_equal e, extract_mentioned_screen_names_with_indices(text), description
  end

  def_conformance_test("extract.yml", :mentions_or_lists_with_indices) do
    e = expected.map{|elem| elem.inject({}){|h, (k,v)| h[k.to_sym] = v; h} }
    assert_equal e, extract_mentions_or_lists_with_indices(text), description
  end

  def_conformance_test("extract.yml", :urls) do
    assert_equal expected, extract_urls(text), description
    expected.each do |expected_url|
      assert_equal true, valid_url?(expected_url, true, false), "expected url [#{expected_url}] not valid"
    end
  end

  def_conformance_test("extract.yml", :urls_with_indices) do
    e = expected.map{|elem| elem.inject({}){|h, (k,v)| h[k.to_sym] = v; h} }
    assert_equal e, extract_urls_with_indices(text), description
  end

  def_conformance_test("extract.yml", :hashtags) do
    assert_equal expected, extract_hashtags(text), description
  end

  def_conformance_test("extract.yml", :hashtags_with_indices) do
    e = expected.map{|elem| elem.inject({}){|h, (k,v)| h[k.to_sym] = v; h} }
    assert_equal e, extract_hashtags_with_indices(text), description
  end

  # Autolink Conformance
  def_conformance_test("autolink.yml", :usernames) do
    assert_equal_without_attribute_order expected, auto_link_usernames_or_lists(text, :suppress_no_follow => true), description
  end

  def_conformance_test("autolink.yml", :lists) do
    assert_equal_without_attribute_order expected, auto_link_usernames_or_lists(text, :suppress_no_follow => true), description
  end

  def_conformance_test("autolink.yml", :urls) do
    assert_equal_without_attribute_order expected, auto_link_urls(text, :suppress_no_follow => true), description
  end

  def_conformance_test("autolink.yml", :hashtags) do
    assert_equal_without_attribute_order expected, auto_link_hashtags(text, :suppress_no_follow => true), description
  end

  def_conformance_test("autolink.yml", :all) do
    assert_equal_without_attribute_order expected, auto_link(text, :suppress_no_follow => true), description
  end

  # HitHighlighter Conformance
  def_conformance_test("hit_highlighting.yml", :plain_text) do
    assert_equal expected, hit_highlight(text, hits), description
  end

  def_conformance_test("hit_highlighting.yml", :with_links) do
    assert_equal expected, hit_highlight(text, hits), description
  end

  # Validation Conformance
  def_conformance_test("validate.yml", :tweets) do
    assert_equal expected, valid_tweet_text?(text), description
  end

  def_conformance_test("validate.yml", :usernames) do
    assert_equal expected, valid_username?(text), description
  end

  def_conformance_test("validate.yml", :lists) do
    assert_equal expected, valid_list?(text), description
  end

  def_conformance_test("validate.yml", :urls) do
    assert_equal expected, valid_url?(text), description
  end

  def_conformance_test("validate.yml", :urls_without_protocol) do
    assert_equal expected, valid_url?(text, true, false), description
  end

  def_conformance_test("validate.yml", :hashtags) do
    assert_equal expected, valid_hashtag?(text), description
  end

  def_conformance_test("validate.yml", :lengths) do
    assert_equal expected, tweet_length(text), description
  end
end
