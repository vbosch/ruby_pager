
module RubyPager

  class Page
    attr_reader :file_name, :text_regions
    def initialize(ex_file_name)
      @file_name=ex_file_name;
      @full_data=XML.load(@file_name)
      @text_regions=Hash.new
      load_text_regions()
    end

    def save(ex_save_name)
      consolidate_data()
      XML.save(ex_save_name,@full_data)
    end

    def load_text_regions()
      region_array= @full_data["PcGts"]["Page"]["TextRegion"]
      region_array.each_with_index {|text_region,index |
        @text_regions[text_region["@id"]]=Text_Region.new(index,text_region)
      }
    end

    def consolidate_data()

    end

  end

end