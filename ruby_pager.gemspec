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
	    spec.metadata["allowed_push_host"] = "https://rubygems.org"
	      else
	          raise "RubyGems 2.0 or newer is required to protect against " \
	          	        "public gem pushes."
	          	          end

	          	            spec.files         = `git ls-files -z`.split("\x0").reject do |f|
	          	                f.match(%r{^(test|spec|features)/})
	  end
	  	  spec.bindir = 'bin' 
	      spec.executables   = ["baseline_noise","line_edit","page_create","region_edit"]
	        spec.require_paths = ["lib"]
	          spec.add_development_dependency "bundler"
	            spec.add_development_dependency "rake"
	              spec.add_development_dependency "rspec"
	                spec.add_development_dependency "aruba"
	                  spec.add_development_dependency "simplecov"
	                    spec.add_dependency "pry"
	                      spec.add_dependency "rgeo"
	                        spec.add_dependency "gosu"
	                          spec.add_dependency "rmagick"
	                            spec.add_dependency "optimist"
	                              spec.add_dependency "nori"
	                                spec.add_dependency "awesome_print"
	                                  spec.add_dependency "nokogiri"
	                                    spec.add_dependency "extendmatrix"
	                                    end
