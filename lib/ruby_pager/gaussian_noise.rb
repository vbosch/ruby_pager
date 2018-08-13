
module RubyPager

  class GaussianNoise
    def initialize(ex_mean, ex_stddev, ex_rand_helper = lambda { Kernel.rand })
      @rand_helper = ex_rand_helper
      @mean = ex_mean
      @stddev = ex_stddev
      @valid = false
      @next = 0
    end

    def rand
      if @valid then
        @valid = false
        return @next
      else
        @valid = true
        x, y = self.class.gaussian(@mean, @stddev, @rand_helper)
        @next = y
        return x
      end
    end

    private
    def self.gaussian(mean, stddev, rand)
      theta = 2 * Math::PI * rand.call
      rho = Math.sqrt(-2 * Math.log(1 - rand.call))
      scale = stddev * rho
      x = mean + scale * Math.cos(theta)
      y = mean + scale * Math.sin(theta)
      return x, y
    end
  end

end