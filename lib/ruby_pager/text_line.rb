
module RubyPager

  class Text_Line
    attr_reader :id, :text ,:coords, :baseline
    def initialize(ex_index, ex_data)
      @full_data=ex_data
      @index=ex_index
      @id = @full_data["@id"]
      @text = @full_data["TextEquiv"]["Unicode"]
      load_coords()
      load_baseline()

    end

    def load_coords()

    end

    def load_baseline()

    end
  end

end