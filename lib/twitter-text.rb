major, minor, patch = RUBY_VERSION.split('.')

$RUBY_1_9 = if major.to_i == 1 && minor.to_i < 9
  # Ruby 1.8 KCODE check. Not needed on 1.9 and later.
  raise("twitter-text requires the $KCODE variable be set to 'UTF8' or 'u'") unless $KCODE[0].chr =~ /u/i
  false
else
  true
end

require 'active_support'
require 'active_support/core_ext/string/multibyte.rb'

require File.join(File.dirname(__FILE__), 'twitter-text', 'regex')
require File.join(File.dirname(__FILE__), 'twitter-text', 'rewriter')
require File.join(File.dirname(__FILE__), 'twitter-text', 'autolink')
require File.join(File.dirname(__FILE__), 'twitter-text', 'extractor')
require File.join(File.dirname(__FILE__), 'twitter-text', 'unicode')
require File.join(File.dirname(__FILE__), 'twitter-text', 'validation')
require File.join(File.dirname(__FILE__), 'twitter-text', 'hithighlighter')
