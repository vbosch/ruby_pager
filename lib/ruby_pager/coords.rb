require "rgeo"
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

    def each
      @points.each {|point| yield point}
    end

    def [](ex_index)
      raise(RangeError, "Index #{ex_index} is out of range") unless ex_index.between?(0,@points.size-1)
      return @points[ex_index]
    end

    def avg_height
      total=0.0
      @points.each{|coord| total+=coord.y}
      total/size
    end

    def min_height
      max=-1
      @points.each{|coord| max= max > coord.y ? max : coord.y}
      return max
    end

    def max_height
      min = -1
      min=@points[0].y if size > 0
      @points.each{|coord| min= min < coord.y ? min : coord.y}
      return min
    end

    def max_width
      max=-1
      @points.each{|coord| max= max > coord.x ? max : coord.x}
      return max
    end

    def min_width
      min = -1
      min=@points[0].x if size > 0
      @points.each{|coord| min= min < coord.x ? min : coord.x}
      return min
    end

    def height
      min_height-max_height
    end
    def width
      max_width-min_width
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

    def get_line_representation
      return RGeo::Cartesian.factory.line_string(get_rgeo_points)
    end

    def get_polygon_representation
      return RGeo::Cartesian.factory.polygon(get_line_representation)
    end

    def self.blank_data
      res = ""
      return res
    end


    private

    def get_rgeo_points
      rgeo_points = Array.new
      @points.each {|coord|rgeo_points.push(coord.point)}
      return rgeo_points
    end

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