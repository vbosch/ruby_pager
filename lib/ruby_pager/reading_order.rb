module RubyPager
  class Reading_Order
    def initialize(ex_data)
      @data=ex_data
      #ap @data
    end

    def get_consolidated_data
      consolidate_data()
      return @data
    end

    private
    def consolidate_data

    end
  end
end