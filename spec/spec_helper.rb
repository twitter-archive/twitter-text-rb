$TESTING=true
$KCODE='u'
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'nokogiri'
require 'simplecov'
SimpleCov.start do
  add_group 'Libraries', 'lib'
end

require File.expand_path('../../lib/twitter-text', __FILE__)
require File.expand_path('../test_urls', __FILE__)

RSpec.configure do |config|
  config.include TestUrls
end

RSpec::Matchers.define :match_autolink_expression do
  match do |string|
    Twitter::Regex[:valid_url].match(string)
  end
end

RSpec::Matchers.define :match_autolink_expression_in do |text|
  match do |url|
    @match_data = Twitter::Regex[:valid_url].match(text)
    @match_data && @match_data.to_s.strip == url
  end

  failure_message_for_should do |url|
    "Expected to find url '#{url}' in text '#{text}', but the match was #{@match_data.captures}'"
  end
end

RSpec::Matchers.define :have_autolinked_url do |url, inner_text|
  match do |text|
    @link = Nokogiri::HTML(text).search("a[@href='#{url}']")
    @link &&
    @link.inner_text &&
    (inner_text && @link.inner_text == inner_text) || (!inner_text && @link.inner_text == url)
  end

  failure_message_for_should do |text|
    "Expected url '#{url}'#{", inner_text '#{inner_text}'" if inner_text} to be autolinked in '#{text}'"
  end
end

RSpec::Matchers.define :link_to_screen_name do |screen_name|
  match do |text|
    @link = Nokogiri::HTML(text).search("a.username")
    @link && @link.inner_text == screen_name && "http://twitter.com/#{screen_name}".downcase.should == @link.first['href']
  end

  failure_message_for_should do |text|
    "expected link #{@link.inner_text} with href #{@link['href']} to match screen_name #{@screen_name}, but it does not"
  end

  failure_message_for_should_not do |text|
    "expected link #{@link.inner_text} with href #{@link['href']} not to match screen_name #{@screen_name}, but it does"
  end

  description do
    "contain a link with the name and href pointing to the expected screen_name"
  end
end

RSpec::Matchers.define :link_to_list_path do |list_path|
  match do |text|
    @link = Nokogiri::HTML(text).search("a.list-slug")
    !@link.nil? && @link.inner_text == list_path && "http://twitter.com/#{list_path}".downcase.should == @link.first['href']
  end

  failure_message_for_should do |text|
    "expected link #{@link.inner_text} with href #{@link['href']} to match the list path #{list_path}, but it does not"
  end

  failure_message_for_should_not do |text|
    "expected link #{@link.inner_text} with href #{@link['href']} not to match the list path #{@list_path}, but it does"
  end

  description do
    "contain a link with the list title and an href pointing to the list path"
  end
end

RSpec::Matchers.define :have_autolinked_hashtag do |hashtag|
  match do |text|
    @link = Nokogiri::HTML(text).search("a[@href='http://twitter.com/search?q=#{hashtag.sub(/^#/, '%23')}']")
    @link &&
    @link.inner_text &&
    @link.inner_text == hashtag
  end

  failure_message_for_should do |text|
    if @link
      "Expected link text to be [#{hashtag}], but it was [#{@link.inner_text}] in #{text}"
    else
      "Expected hashtag #{hashtag} to be autolinked in '#{text}', but no link was found."
    end
  end
end
