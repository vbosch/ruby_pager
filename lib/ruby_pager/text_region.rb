
module RubyPager

  class Text_Region
    attr_reader :id, :custom ,:text_lines
    def initialize(ex_index, ex_data)
      @full_data=ex_data
      @index=ex_index
      @id = @full_data["@id"]
      @custom=@full_data["@custom"]
      @text_lines=Hash.new
      load_text_lines()
    end

    def load_text_lines()
      line_array=@full_data["TextLine"]
      line_array.each_with_index {|text_line,index |
        @text_lines[text_line["@id"]]=Text_Line.new(index,text_line)
      }
    end

    def get_consolidated_data

    end

  end

end