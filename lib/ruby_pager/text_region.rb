
module RubyPager

  class Text_Region
    attr_reader :id, :custom
    def initialize(ex_index, ex_data)
      @data=ex_data
      @index=ex_index
      @id = @data["@id"]
      @custom=@data["@custom"]
      @text_lines=Hash.new
      load_text_lines()
    end

    def size
      return @text_lines.size
    end

    def id= (region_id)

    end
    
    def index= (region_id)

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

    private

    def load_text_lines()
      line_array=@data["TextLine"]
      line_array.each_with_index {|text_line,index |
        @text_lines[text_line["@id"]]=Text_Line.new(index,text_line)
      }
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