
module RubyPager

  class Page
    attr_reader :file_name, :metadata, :image_data, :xmlns, :xmlns_xsi, :xsi_schemaLocation
    def initialize(ex_file_name,ex_data)
      @logger = Utils::ApplicationLogger.instance
      @logger.info("Loading data from XML #{ex_file_name}")
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
      logger = Utils::ApplicationLogger.instance
      logger.info("Loading XML #{ex_file_name}")
      data=XML.load(ex_file_name)
      return Page.new(ex_file_name,data)
    end

    def self.create_from_image(ex_image_name)
      logger = Utils::ApplicationLogger.instance
      logger.info("Generating XML for image #{ex_image_name}")
      image=Utils::Image.new(ex_image_name)
      data=self.blank_data
      data["PcGts"]["Page"]["@imageFilename"]=ex_image_name
      data["PcGts"]["Page"]["@imageWidth"]=image.rows.to_s
      data["PcGts"]["Page"]["@imageHeight"]=image.columns.to_s
      return Page.new(ex_image_name,data)
    end

    def self.blank(ex_image_name)
      data=self.blank_data
      return Page.new(ex_image_name,data)
    end

    def create_full_page_region(region_id)
      @logger.info("Creating full page region #{region_id}")
      data=Text_Region.blank_data
      raise(ArgumentError, "Region id #{region_id} is already in use") if @text_regions.has_key? region_id
      data["Coords"]["@points"]="0,0 0,#{@image_data.width} #{@image_data.height},#{@image_data.width} #{@image_data.height},0"
      data["@id"]=region_id
      push(Text_Region.new(0,data))
    end

    def save(ex_save_name=@file_name)
      @logger.info("Saving page object #{@file_name} to #{ex_save_name}")
      consolidate_data
      XML.save(ex_save_name, @data)
    end


    def [](ex_key)
      raise(RangeError, "Index #{ex_key} is out of range") unless @text_regions.has_key? ex_key
      return @text_regions[ex_key]
    end

    def has_region?(ex_region_id)
      return @text_regions.has_key? ex_region_id
    end

    def delete(ex_region_id)
      if has_region? ex_region_id
        @logger.info("Deleting text region #{ex_region_id}")
        @text_regions.delete(ex_region_id)
        review_regions_index()
      else
        raise(ArgumentError, "Region id #{ex_region_id} does not exist so it can not be deleted")
      end
    end

    def push(ex_text_region)
      raise(ArgumentError, "Got passed a non text region object") if ex_text_region.class != RubyPager::Text_Region
      raise(ArgumentError, "Region id #{ex_text_region.id} is already in use") if @text_regions.has_key? ex_text_region.id
      ex_text_region.index=@text_regions.size
      @text_regions[ex_text_region.id]=ex_text_region
    end

    def size
      return @text_regions.size
    end

    def self.blank_data
      logger = Utils::ApplicationLogger.instance
      logger.info("Creating blank XML data")
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

    def review_regions_index
      index =0
      @text_regions.values.each {|region|
        region.index=index
        index+=1
      }
    end

    def load_text_regions
      if @data["PcGts"]["Page"]["TextRegion"]
        if @data["PcGts"]["Page"]["TextRegion"].class == Array
          region_array= @data["PcGts"]["Page"]["TextRegion"]
          region_array.each_with_index {|text_region,index |
            @text_regions[text_region["@id"]]=Text_Region.new(index,text_region)
          }
        end
        if @data["PcGts"]["Page"]["TextRegion"].class == Hash
          text_region= @data["PcGts"]["Page"]["TextRegion"]
          @text_regions[text_region["@id"]]=Text_Region.new(0,text_region)
        end
      end
    end

    def load_xml_schema_data
      @xmlns_xsi=@data["PcGts"]["@xmlns:xsi"]
      @xmlns= @data["PcGts"]["@xmlns"]
      @xsi_schemaLocation=@data["PcGts"]["@xsi:schemaLocation"]
      @pc_gts_id=@data["PcGts"]["@pcGtsId"]
    end

    def load_xml_image_info
      @image_data = Image_Data.new(@data["PcGts"]["Page"])
    end

    def consolidate_data
      @data["PcGts"]["Metadata"]=@metadata.get_consolidated_data
      @data["PcGts"]["@xmlns:xsi"]=@xmlns_xsi
      @data["PcGts"]["@xmlns"]=@xmlns
      @data["PcGts"]["@xsi:schemaLocation"]=@xsi_schemaLocation
      @data["PcGts"]["@pcGtsId"]=@pc_gts_id
      @data["PcGts"]["Page"]["ReadingOrder"]=@reading_order.get_consolidated_data
      img_cons = @image_data.get_consolidated_data
      @data["PcGts"]["Page"]["@imageFilename"]=img_cons["@imageFilename"]
      @data["PcGts"]["Page"]["@imageWidth"]=img_cons["@imageWidth"]
      @data["PcGts"]["Page"]["@imageHeight"]=img_cons["@imageHeight"]
      @data["PcGts"]["Page"]["TextRegion"]=Array.new
      @text_regions.values.each {|text_region|
        @data["PcGts"]["Page"]["TextRegion"].push(text_region.get_consolidated_data)
      }

    end

  end

end