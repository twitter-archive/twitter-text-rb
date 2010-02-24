module TestUrls
  VALID = [
    "http://google.com",
    "http://google.com/#",
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
    "http://www.flickr.com/photos/29674651@N00/4382024406",
    "http://www.flickr.com/photos/29674651@N00/foobar",
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
    "I'll just drop a <%= url %> right in the middle of a sentence.",
    "I think it's proper to end sentences with a period <%= url %>. Even when they contain a URL.",
    "Sometimes I'll wrap one in parens (<%= url %>) as an aside.",
    "A colon with no spaces is a great way to address my friend @mzsanford:<%= url %>",
    "There are no spaces between characters in Japanese:  いまなにしてる<%= url %>いまなにしてる",
  ]

end
