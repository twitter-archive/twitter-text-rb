# Backward Compatibility

load File.expand_path("../twitter_text.rb", __FILE__)

module Twitter
  include TwitterText
end
