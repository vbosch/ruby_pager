
module RubyPager
  class Coord

    attr_reader :id, :x , :y
    def initialize(ex_index,ex_data)
      @data = ex_data
      @id = ex_index
      load_coords()
    end

    def load_coords()
      separate = @data.split(",")
      raise(StandardError,"Got passed coord data that doesn't have exactly two dimensions")if separate.size !=2
      @x = separate[0].to_i
      @y = separate[1].to_i
    end
  end
end