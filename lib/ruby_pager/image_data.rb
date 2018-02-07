
module RubyPager

  class Image_Data

    attr_reader :file_name ,:width ,:height
    def initialize(ex_data)
      @data=Hash.new
      @data["@imageFilename"]=ex_data["@imageFilename"]
      @data["@imageWidth"]=ex_data["@imageWidth"]
      @data["@imageHeight"]=ex_data["@imageHeight"]
      @file_name = @data["@imageFilename"]
      @width = @data["@imageWidth"].to_i
      @height = @data["@imageHeight"].to_i
    end

    def file_name= (ex_file_name)
      raise(ArgumentError, "Got passed a non string object") if ex_file_name.class != String
      @file_name=ex_file_name
    end

    def width=(ex_width)
      raise(ArgumentError, "Got passed a non integer object") if ex_width.class != Fixnum or ex_width < 0
      @width=ex_width
    end

    def height=(ex_height)
      raise(ArgumentError, "Got passed a non integer object") if ex_height.class != Fixnum or ex_height < 0
      @height=ex_height
    end

    def self.blank_data
      res=Hash.new
      res["@imageFilename"]=""
      res["@imageWidth"]="0"
      res["@imageHeight"]="0"
      return res
    end

    def get_consolidated_data
      consolidate_data()
      return @data
    end

    private

    def consolidate_data()
      @data["@imageFilename"]=@file_name
      @data["@imageWidth"]=@width.to_s
      @data["@imageHeight"]=@height.to_s
    end
  end
end