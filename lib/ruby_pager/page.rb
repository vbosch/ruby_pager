
module RubyPager

  class Page
    attr_reader :file_name
    def initialize(ex_file_name)
      @file_name=ex_file_name;
      @data=XML.load(@file_name)
    end
  end

end