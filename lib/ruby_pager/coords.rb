
module RubyPager

  class Coords
    attr_reader :points
    def initialize(ex_coords_string)
      @coords_string = ex_coords_string
      @points=Array.new
      load_points()
    end

    def load_points()
      coord_string_array= @coords_string.split
      coord_string_array.each_with_index {|string_coord,index|
        @points.push(Coord.new(index,string_coord))
      }
    end
  end

end