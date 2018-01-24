require 'nokogiri'
require 'nori'
module RubyPager


  class XML
    def self.exists?(file_name)
      if file_name.end_with?(".xml")
        return File.file?(file_name)
      end
      return false
    end

    def self.load(file_name)
      if self.exists?(file_name)
        xml  = Nokogiri::XML(File.open(file_name)) { |config| config.strict.noblanks }
        hash = Nori.new(:parser => :nokogiri, :advanced_typecasting => false).parse(xml.to_s)
        return hash
      end
      return nil
    end
  end

end