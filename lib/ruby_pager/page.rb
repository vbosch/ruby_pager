
module RubyPager

  class Page
    attr_reader :file_name, :metadata, :image_filename, :image_height, :image_width, :xmlns, :xmlns_xsi, :xsi_schemaLocation
    def initialize(ex_file_name,ex_data)
      @file_name=ex_file_name
      @data=ex_data
      @text_regions=Hash.new
      @metadata=Metadata.new(@data["PcGts"]["Metadata"])
      load_xml_schema_data
      load_xml_image_info
      load_text_regions
      @reading_order=Reading_Order.new(@data["PcGts"]["Page"]["ReadingOrder"])
    end

    def self.load_from_xml(ex_file_name)
      data=XML.load(ex_file_name)
      return Page.new(ex_file_name,data)
    end

    def self.create_from_image(ex_image_name)
      image=Utils::Image.new(ex_image_name)
      data=self.blank_data
      data["PcGts"]["Page"]["@imageFilename"]=ex_image_name
      data["PcGts"]["Page"]["@imageWidth"]=image.rows.to_s
      data["PcGts"]["Page"]["@imageHeight"]=image.columns.to_s
      return Page.new(ex_image_name,data)
    end

    def create_full_page_region(region_id)
      data=Text_Region.blank_data
      raise(ArgumentError, "Region id #{region_id} is already in use") if @text_regions.has_key? region_id
      data["Coords"]["@points"]="0,0 0,#{image_width} #{image_height},#{image_width} #{image_height},0"
      data["@id"]=region_id
      push(Text_Region.new(0,data))
    end

    def save(ex_save_name=@file_name)
      consolidate_data
      #ap @data
      XML.save(ex_save_name, @data)
    end


    def [](ex_key)
      raise(RangeError, "Index #{ex_key} is out of range") unless @text_regions.has_key? ex_key
      return @text_regions[ex_key]
    end

    def push(ex_text_region)
      raise(ArgumentError, "Got passed a non text region object") if ex_text_region.class != RubyPager::Text_Region
      raise(ArgumentError, "Region id #{region_id} is already in use") if @text_regions.has_key? ex_text_region.id
      ex_text_region.index=@text_regions.size
      ap @text_regions.size
      @text_regions[ex_text_region.id]=ex_text_region
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
      res["PcGts"]["Page"]["TextRegion"]=Array.new
      res["PcGts"]["Page"]["ReadingOrder"]=Hash.new
      res["PcGts"]["Page"]["@imageFilename"]="blank.jpg"
      res["PcGts"]["Page"]["@imageWidth"]="0"
      res["PcGts"]["Page"]["@imageHeight"]="0"
      return res
    end

    private

    def load_text_regions
      region_array= @data["PcGts"]["Page"]["TextRegion"]
      region_array.each_with_index {|text_region,index |
        @text_regions[text_region["@id"]]=Text_Region.new(index,text_region)
      }
    end

    def load_xml_schema_data
      @xmlns_xsi=@data["PcGts"]["@xmlns:xsi"]
      @xmlns= @data["PcGts"]["@xmlns"]
      @xsi_schemaLocation=@data["PcGts"]["@xsi:schemaLocation"]
      @pc_gts_id=@data["PcGts"]["@pcGtsId"]
    end

    def load_xml_image_info
      @image_filename= @data["PcGts"]["Page"]["@imageFilename"]
      @image_width= @data["PcGts"]["Page"]["@imageWidth"].to_i
      @image_height= @data["PcGts"]["Page"]["@imageHeight"].to_i
    end

    def consolidate_data
      @data["PcGts"]["Metadata"]=@metadata.get_consolidated_data
      @data["PcGts"]["@xmlns:xsi"]=@xmlns_xsi
      @data["PcGts"]["@xmlns"]=@xmlns
      @data["PcGts"]["@xsi:schemaLocation"]=@xsi_schemaLocation
      @data["PcGts"]["@pcGtsId"]=@pc_gts_id
      @data["PcGts"]["Page"]["ReadingOrder"]=@reading_order.get_consolidated_data
      @data["PcGts"]["Page"]["@imageFilename"]=@image_filename
      @data["PcGts"]["Page"]["@imageWidth"]=@image_width
      @data["PcGts"]["Page"]["@imageHeight"]=@image_height
      @data["PcGts"]["Page"]["TextRegion"]=Array.new
      @text_regions.values.each {|text_region|
        @data["PcGts"]["Page"]["TextRegion"].push(text_region.get_consolidated_data)
      }

    end

  end

end