
module RubyPager

  class Coords
    def initialize(ex_coords_string)
      @data = ex_coords_string
      @points=Array.new
      load_points()
    end

    def size
      return @points.size
    end

    def [](ex_index)
      raise(RangeError, "Index #{ex_index} is out of range") unless ex_index.between?(0,@points.size-1)
      return @points[ex_index]
    end

    def get_consolidated_data
      consolidate_data()
      return @data
    end

    def push(ex_coord)
      raise(ArgumentError, "Got passed a non coord object") if ex_coord.class != RubyPager::Coord
      @points.push(ex_coord)
    end

    private

    def load_points()
      coord_string_array= @data.split
      coord_string_array.each_with_index {|string_coord,index|
        @points.push(Coord.new(index,string_coord))
      }
    end

    def consolidate_data

    end

  end

end