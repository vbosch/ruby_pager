
module RubyPager

  class Text_Line
    attr_reader :id, :index  ,:text ,:contour, :baseline
    def initialize(ex_index, ex_data)
      @data=ex_data
      @index=ex_index
      @id = @data["@id"]
      @text = @data["TextEquiv"]["Unicode"]
      load_coords()
      load_baseline()

    end

    def self.blank
      return Text_Line.new(0,Text_Line.blank_data)
    end

    def id= ex_id
      raise(ArgumentError, "Got passed a non string object") if ex_id.class != String
      @id=ex_id
    end

    def text= ex_text
      raise(ArgumentError, "Got passed a non string object") if ex_text.class != String
      @text=ex_text
    end

    def index=(ex_index)
      raise(ArgumentError, "Got passed a negative value to update the index") if ex_index.to_i < 0
      @index=ex_index.to_i
    end

    def get_consolidated_data
      consolidate_data()
      return @data
    end

    def self.blank_data
      res=Hash.new
      res["@id"]=""
      res["TextEquiv"]=Hash.new
      res["TextEquiv"]["Unicode"]=""
      res["Baseline"]=Hash.new
      res["Baseline"]["@points"]=Coords.blank_data
      res["Coords"]=Hash.new
      res["Coords"]["@points"]=Coords.blank_data
      return res
    end
    private

    def load_coords()
      @contour = Coords.new(@data["Coords"]["@points"]);
    end

    def load_baseline()
      @baseline = Coords.new(@data["Baseline"]["@points"]);
    end

    def consolidate_data()
      @data["@id"]=@id
      @data["TextEquiv"]["Unicode"]=@text
      @data["Baseline"]["@points"]=@baseline.get_consolidated_data
      @data["Coords"]["@points"]=@contour.get_consolidated_data
    end
  end

end