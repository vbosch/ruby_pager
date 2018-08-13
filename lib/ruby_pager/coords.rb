
module RubyPager

  class Coords
    def initialize(ex_coords_string)
      @data = ex_coords_string
      @points=Array.new
      load_points()
    end

    def self.blank
      return Coords.new(Coords.blank_data)
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
      ex_coord.id=@points.size
      @points.push(ex_coord)
    end

    def clear
      @points.clear
    end

    def reload(ex_coord_string)
      clear
      @data=ex_coord_string
      load_points
    end

    def delete(ex_delete_index)
      @points.delete_at(ex_delete_index)
      review_points_index()
    end

    def vertical_noise(ex_std_dev)
      @points.each {|point| point.vertical_noise(ex_std_dev)}
    end

    def self.blank_data
      res = ""
      return res
    end
    private

    def load_points()
      coord_string_array= @data.split
      coord_string_array.each_with_index {|string_coord,index|
        @points.push(Coord.new(index,string_coord))
      }
    end

    def consolidate_data
      @data=""
      @points.each {|point|
        @data+=" " if @data.size() > 0
        @data+= point.get_consolidated_data}
    end

    def review_points_index
      @points.each_with_index {|point,index |
        point.id=index}
    end

  end

end