module TestUrls
  VALID = [
    "http://google.com",
    "http://foobar.com/#",
    "http://google.com/#foo",
    "http://google.com/#search?q=iphone%20-filter%3Alinks",
    "http://twitter.com/#search?q=iphone%20-filter%3Alinks",
    "http://www.boingboing.net/2007/02/14/katamari_damacy_phon.html",
    "http://somehost.com:3000",
    "http://x.com/~matthew+%-x",
    "http://en.wikipedia.org/wiki/Primer_(film)",
    "http://www.ams.org/bookstore-getitem/item=mbk-59",
    "http://chilp.it/?77e8fd",
    "www.foobar.com",
    "WWW.FOOBAR.COM",
    "http://tell.me/why",
    "http://longtlds.info",
    "http://✪df.ws/ejp",
    "http://日本.com",
    # "http://www.flickr.com/photos/29674651@N00/4382024406",
    # "http://www.flickr.com/photos/29674651@N00/foobar",
  ]

  INVALID = [ 
    "http://no-tld",
    "http://tld-too-short.x",
    "http://x.com/,,,/.../@@@/;;;/:::/---/%%%x",
    "http://domain-dash.com",
    "http://-doman_dash.com"
  ]

  EMBED_TEXT = [
    "I enjoy a good URL now and again: <%= url %>",
    "I'll just drop one <%= url %> right in the middle of a conversation.",
    "Sometimes I put them in parens (<%= url %>) for fun",
    "Finding spaces after colons disagreeable, I show them to my friend @mzsanford:<%= url %>",
    "いまなにしてる<%= url %>いまなにしてる",
  ]

end
