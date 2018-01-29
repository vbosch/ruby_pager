
module RubyPager

  class Text_Line
    attr_reader :id, :text ,:contour, :baseline
    def initialize(ex_index, ex_data)
      @full_data=ex_data
      @index=ex_index
      @id = @full_data["@id"]
      @text = @full_data["TextEquiv"]["Unicode"]
      load_coords()
      load_baseline()

    end

    def load_coords()
      @contour = Coords.new(@full_data["Coords"]["@points"]);
    end

    def load_baseline()
      @baseline = Coords.new(@full_data["Baseline"]["@points"]);
    end

    def get_consolidated_data

    end
  end

end