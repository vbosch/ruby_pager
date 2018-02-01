
module RubyPager

  class Page
    attr_reader :file_name, :metadata
    def initialize(ex_file_name,ex_data)
      @file_name=ex_file_name;
      @data=XML.load(@file_name)
      @text_regions=Hash.new
      @metadata=Metadata.new(@data["PcGts"]["Metadata"])
      load_xml_schema_data()
      load_xml_image_info()
      load_text_regions()
      @reading_order=Reading_Order.new(@data["PcGts"]["Page"]["ReadingOrder"])
    end

    def self.load_from_xml(ex_file_name)
      data=XML.load(ex_file_name)
      return Page.new(ex_file_name,data)
    end

    def save(ex_save_name=@file_name)
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

    def self.blank_data
      res=Hash.new
      res["PcGts"]=Hash.new
      res["PcGts"]["Metadata"]=Metadata.blank_data
      res["PcGts"]["@xmlns:xsi"]="http://www.w3.org/2001/XMLSchema-instance"
      res["PcGts"]["@xmlns"]="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15"
      res["PcGts"]["@xsi:schemaLocation"]="http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15 http://schema.primaresearch.org/PAGE/gts/pagecontent/2013-07-15/pagecontent.xsd"
      res["PcGts"]["@pcGtsId"]=""
      res["PcGts"]["Page"]=Hash.new
      res["PcGts"]["Page"]["TextRegion"]=Text_Region.blank_data
      res["PcGts"]["Page"]["ReadingOrder"]=Hash.new
      res["PcGts"]["Page"]["@imageFilename"]="blank.jpg"
      res["PcGts"]["Page"]["@imageWidth"]="0"
      res["PcGts"]["Page"]["@imageHeigh"]="0"
      return res
    end

    private

    def load_text_regions()
      region_array= @data["PcGts"]["Page"]["TextRegion"]
      region_array.each_with_index {|text_region,index |
        @text_regions[text_region["@id"]]=Text_Region.new(index,text_region)
      }
    end

    def load_xml_schema_data()
      @xmlns_xsi=@data["PcGts"]["@xmlns:xsi"]
      @xmlns= @data["PcGts"]["@xmlns"]
      @xsi_schemaLocation=@data["PcGts"]["@xsi:schemaLocation"]
      @pc_gts_id=@data["PcGts"]["@pcGtsId"]
    end

    def load_xml_image_info()
      @image_filename= @data["PcGts"]["Page"]["@imageFilename"]
      @image_width= @data["PcGts"]["Page"]["@imageWidth"].to_i
      @image_height= @data["PcGts"]["Page"]["@imageHeigh"].to_i
    end

    def consolidate_data()

    end

  end

end