Gem::Specification.new do |s|
  s.name = "blockwalker"
  s.version = "0.1.0.pre"
  s.date = "2013-04-20"
  s.summary = "Parse bitcoin blocks."
  s.description = "Turns raw bitcoin blocks into ruby objects."
  s.authors = ["Grant T. Olson"]
  s.email = "kgo@grant-olson.net"
  s.files = ["LICENSE",
             "lib/blockwalker.rb",
	     "lib/blockwalker/readers.rb",
	     "lib/blockwalker/script.rb",
	     "lib/blockwalker/input.rb",
	     "lib/blockwalker/output.rb",
	     "lib/blockwalker/transaction.rb",
	     "lib/blockwalker/block.rb",
            ]
  s.test_files = []
  s.homepage = "https://github.com/grant-olson/blockwalker"
  s.license = "BSD 3 Clause"
end