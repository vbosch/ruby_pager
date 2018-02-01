module RubyPager
  class Metadata

    attr_reader :creator
    def initialize(ex_data)
      @data=ex_data
      @creator = @data["Creator"]
      @created = DateTime.parse(@data["Created"])
      @lastchange = DateTime.parse(@data["LastChange"])
    end

    def creator= (ex_creator)
      raise(ArgumentError, "Got passed a non string object") if ex_creator.class != String
      @creator=ex_creator
    end

    def created
      return @created.strftime("%FT%T")
    end

    def created= (ex_created)
      raise(ArgumentError, "Got passed a non DateTime object") if ex_created.class != DateTime
      @created=ex_created
    end

    def lastchange
      return @lastchange.strftime("%FT%T")
    end

    def lastchange= (ex_lastchange)
      raise(ArgumentError, "Got passed a non DateTime object") if ex_lastchange.class != DateTime
      @lastchange=ex_lastchange
    end

    def self.blank_data
      res=Hash.new
      res["Creator"]="Ruby Page"
      res["Created"]=DateTime.now.strftime("%FT%T")
      res["LastChange"]=DateTime.now.strftime("%FT%T")
      return res
    end

    def get_consolidated_data
      consolidate_data()
      return @data
    end

    private

    def consolidate_data()
      @data["Creator"]=@creator
      @data["Created"]=self.created
      @data["LastChange"]=self.lastchange
    end
  end
end