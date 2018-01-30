
module RubyPager

  class Page
    attr_reader :file_name
    def initialize(ex_file_name)
      @file_name=ex_file_name;
      @data=XML.load(@file_name)
      @text_regions=Hash.new
      load_text_regions()
    end

    def save(ex_save_name)
      consolidate_data()
      XML.save(ex_save_name, @data)
    end


    def [](ex_key)
      raise(RangeError, "Index #{ex_key} is out of range") unless @text_regions.has_key? ex_key
      return @text_regions[ex_key]
    end

    def size
      return @text_regions.size
    end

    private

    def load_text_regions()
      region_array= @data["PcGts"]["Page"]["TextRegion"]
      region_array.each_with_index {|text_region,index |
        @text_regions[text_region["@id"]]=Text_Region.new(index,text_region)
      }
    end

    def consolidate_data()

    end

  end

end