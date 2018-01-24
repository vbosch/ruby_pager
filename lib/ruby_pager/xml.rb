module RubyPager

  class XML
    def self.exists?(file_name)
      if file_name.end_with?(".xml")
        return File.file?(file_name)
      end
      return false
    end
  end

end