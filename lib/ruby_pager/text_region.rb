
module RubyPager

  class Text_Region
    attr_reader :id, :index, :custom, :contour
    def initialize(ex_index, ex_data)
      @data=ex_data
      @index=ex_index
      @id = @data["@id"]
      @custom=@data["@custom"]
      @text_lines=Hash.new
      load_text_lines()
      load_contour()
    end

    def self.blank
      return Text_Region.new(0,Text_Region.blank_data)
    end

  def size
      return @text_lines.size
    end

    def id= (ex_id)
      raise(ArgumentError, "Got passed a non string object") if ex_id.class != String
      @id=ex_id
    end

    def index= (ex_index)
      raise(ArgumentError, "Got passed a negative value to update the index") if ex_index.to_i < 0
      @index=ex_index.to_i
    end

    def [](ex_key)
      raise(RangeError, "Index #{ex_key} is out of range") unless @text_lines.has_key? ex_key
      return @text_lines[ex_key]
    end

    def has_line? line_id
      return @text_lines.has_key? line_id
    end

    def clear_text_lines()
      @text_lines.clear
    end

    def push(ex_line)
      raise(ArgumentError, "Got passed a non text line object") if ex_line.class != RubyPager::Text_Line
      raise(ArgumentError, "Text line id already in use") if @text_lines.has_key? ex_line.id
      ex_line.index=@text_lines.size
      @text_lines[ex_line.id]=ex_line

    end

    def get_consolidated_data
      consolidate_data()
      return @data
    end

    def self.blank_data
      res=Hash.new
      res["@id"]=""
      res["@custom"]=""
      res["TextLine"]=Array.new
      res["Coords"]=Hash.new
      res["Coords"]["@points"]=Coords.blank_data
      return res
    end

    private

    def load_text_lines()
      line_array=@data["TextLine"]
      line_array.each_with_index {|text_line,index |
        @text_lines[text_line["@id"]]=Text_Line.new(index,text_line)
      }
    end

    def load_contour()
      @contour = Coords.new(@data["Coords"]["@points"]);
    end

    def consolidate_data
      @data["@custom"]=@custom
      @data["@id"]=@id
      @data["TextLine"].clear
      @text_lines.values.each {|text_line|
        @data["TextLine"].push(text_line.get_consolidated_data)
      }
    end

  end

end