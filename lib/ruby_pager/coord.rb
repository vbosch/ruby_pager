
module RubyPager
  class Coord

    attr_reader :id, :x , :y
    def initialize(ex_index,ex_data)
      @data = ex_data
      @id = ex_index
      load_coords()
    end
    def id=(ex_id)
      raise(StandardError, "Got passed a negative value to update the x coord") if ex_id.to_i < 0
      @id=ex_id.to_i
    end

    def x=(x_coord)
      raise(StandardError, "Got passed a negative value to update the x coord") if x_coord.to_i < 0
      @x=x_coord.to_i
    end

    def y=(y_coord)
      raise(StandardError, "Got passed a negative value to update the y coord") if y_coord.to_i < 0
      @y=y_coord.to_i
    end

    def get_consolidated_data
      consolidate_data()
      return @data
    end

    def vertical_noise(ex_std_dev)
      noise_generator=GaussianNoise.new(@y,ex_std_dev)
      @y=noise_generator.rand.to_i
    end

    private

    def load_coords()
      separate = @data.split(",")
      raise(StandardError,"Got passed coord data that doesn't have exactly two dimensions")if separate.size !=2
      @x = separate[0].to_i
      @y = separate[1].to_i
    end

    def consolidate_data
      @data="#{@x},#{@y}"
    end

  end
end