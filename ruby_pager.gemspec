lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
	require "ruby_pager/version"

	Gem::Specification.new do |spec|
	  spec.name          = "ruby_pager"
	    spec.version       = RubyPager::VERSION
	      spec.authors       = ["Vicente Bosch"]
	        spec.email         = ["vbosch@gmail.com"]

	          spec.summary       = "command line tools to read and modify PAGE xmls"
	            spec.description   = "command line tools to read and modify PAGE xmls"
	              spec.homepage      = "https://github.com/vbosch/ruby_pager"
	                spec.license       = "MIT"

	                  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
	                  # to allow pushing to a single host or delete this section to allow pushing to any host.
	                  if spec.respond_to?(:metadata)
	    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
	      else
	          raise "RubyGems 2.0 or newer is required to protect against " \
	          	        "public gem pushes."
	          	          end

	          	            spec.files         = `git ls-files -z`.split("\x0").reject do |f|
	          	                f.match(%r{^(test|spec|features)/})
	  end
	    spec.bindir        = "exe"
	      spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
	        spec.require_paths = ["lib"]
	          spec.add_development_dependency "bundler", "~> 1.16"
	            spec.add_development_dependency "rake", "~> 10.0"
	              spec.add_development_dependency "rspec", "~> 3.0"
	                spec.add_development_dependency "aruba"
	                  spec.add_development_dependency "simplecov"
	                    spec.add_dependency "pry"
	                      spec.add_dependency "rgeo"
	                        spec.add_dependency "gosu"
	                          spec.add_dependency "rmagick"
	                            spec.add_dependency "trollop"
	                              spec.add_dependency "nori"
	                                spec.add_dependency "awesome_print"
	                                  spec.add_dependency "nokogiri"
	                                    spec.add_dependency "extendmatrix"
	                                    end
