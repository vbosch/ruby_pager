require 'aruba/rspec'

logger = Utils::ApplicationLogger.instance
logger.level = Logger::WARN

RSpec.describe RubyPager::XML , :type => :aruba do
  let(:test_file){ './test.xml'}
  let(:imaginary_file){ './doesnotexist.xml'}
  let(:out_file){ './output.xml'}
  before{@data=RubyPager::XML.load(test_file);RubyPager::XML.save(out_file,@data);}
  subject{@data}
  it "has a version number" do
    expect(RubyPager::VERSION).not_to be nil
  end

  it "checks file exists" do
    expect(RubyPager::XML.exists?(test_file)).to eql(true) and expect(RubyPager::XML.exists?(imaginary_file)).to eql(false) and expect(RubyPager::XML.exists?("nothing.txt")).to eql(false)
  end

  it "provides hash of loaded file" do
    expect(RubyPager::XML.load(test_file)).to be_a(Hash)
  end

  it "provides nil when loading incorrect/inexistent file" do
    expect(RubyPager::XML.load("doesnotexist.xml")).to be_nil
  end

  it "saves file to filesystem" do
    check=File.exists?(out_file)
    expect(check).to eql(true)
  end

  it "Saved XML is equivalent to original XML" do
    system("tr -d \" \\t\" < test.xml > difft.xml")
    system("tr -d \" \\t\" < output.xml > diffo.xml")
    diff=`diff diffo.xml difft.xml`
    expect(diff.size).to eq 0
  end

end

RSpec.describe RubyPager::Page , :type => :aruba do
  let(:test_file){ './test.xml'}
  let(:out_page_file){'./page.xml'}
  before{@page=RubyPager::Page.load_from_xml(test_file);}

  it "allows access to file name" do
    expect(@page.file_name).to eql(test_file)
  end

  it "allows access to the metadata" do
    expect(@page.metadata.class).to eql(RubyPager::Metadata)
  end

  it "allows access to the image data" do
    expect(@page.image_data.file_name).to eql("FRCHANJJ_JJ080_0019R_A.jpg") and expect(@page.image_data.width).to eql(3483) and expect(@page.image_data.height).to eql(4715)
  end

  it "allows access to the schema data" do
    expect(@page.xmlns_xsi).not_to be_nil and expect(@page.xmlns).not_to be_nil and expect(@page.xsi_schemaLocation).not_to be_nil
  end

  it "gives access to the text regions inside" do
    expect(@page["TextRegion_1507554599035_50"]).not_to be_nil
  end

  it "saves contents a PAGE xml file" do
    @page.save(out_page_file)
    check=File.exists?(out_page_file)
    expect(check).to eql(true)
  end

  it "loads the correct number of text regions" do
    external_count=`cat test.xml | grep '<TextRegion' | wc -l`.to_i
    expect(@page.size).to eql(external_count)
  end

  it "creates basic xml from image file" do
    img_page = RubyPager::Page.create_from_image("test.jpg")
    check=File.exists?("image.xml")
    img_page.create_full_page_region("ruby_region")
    img_page.save("image.xml")
    external_count=`cat image.xml | grep '<TextRegion' | wc -l`.to_i
    expect(check).to eql(true) and expect(external_count).to eql(1)
  end
end


RSpec.describe RubyPager::Metadata , :type => :aruba do
  let(:test_file){ './test.xml'}
  before{@metadata=RubyPager::Page.load_from_xml(test_file).metadata}
  it "allows access to the creator field" do
    expect(@metadata.creator).to eql("V. Bosch")
  end

  it "allows to change the actual creator field" do
    @metadata.creator = "Pepe"
    expect(@metadata.creator).to eql("Pepe")
  end

  it "throws exception when something other than a string is used to update the creator field" do
    expect{@metadata.creator = 100}.to raise_error(ArgumentError)
  end
  it "allows access to the created field" do
    expect(@metadata.created).to eql("2016-05-20T13:51:57")
  end
  it "allows to change the actual created field" do
    @metadata.created = DateTime.parse("2017-10-25T08:04:56")
    expect(@metadata.created).to eql("2017-10-25T08:04:56")
  end
  it "allows access to the last changed field" do
    expect(@metadata.lastchange).to eql("2017-10-25T08:04:38")
  end
  it "allows to change the actual last changed field" do
    @metadata.lastchange = DateTime.parse("2021-10-25T08:04:56")
    expect(@metadata.lastchange).to eql("2021-10-25T08:04:56")
  end
  it "has a blank data creator" do
    data = RubyPager::Metadata.blank_data()
    expect(data["Creator"]).to eql("Ruby Page") and expect(data["Created"]).to eql(DateTime.now.strftime("%FT%T")) and expect(data["LastChange"]).to eql(DateTime.now.strftime("%FT%T"))
  end


  it "consolidates correctly and gives back updated data in original format" do
    @metadata.creator="Enrique Vidal"
    data= @metadata.get_consolidated_data
    expect(data["Creator"]).to eql("Enrique Vidal")
  end

end
RSpec.describe RubyPager::Metadata , :type => :aruba do
  let(:test_file){ './test.xml'}
  before{@image_data=RubyPager::Page.load_from_xml(test_file).image_data}
  it "allows access to the image file name field" do
    expect(@image_data.file_name).to eql("FRCHANJJ_JJ080_0019R_A.jpg")
  end
  it "allows access to the image height and width" do
    expect(@image_data.width).to eql(3483) and expect(@image_data.height).to eql(4715)
  end

  it "allows to change the actual file name field" do
    @image_data.file_name = "Pepe.jpg"
    expect(@image_data.file_name).to eql("Pepe.jpg")
  end

  it "throws exception when something other than a string is used to update the file name field" do
    expect{@image_data.file_name = 100}.to raise_error(ArgumentError)
  end

  it "allows to change the actual width field" do
    @image_data.width = 3
    expect(@image_data.width).to eql(3)
  end

  it "throws exception when something other than a Fixnum is used to update the width field" do
    expect{@image_data.width = "3"}.to raise_error(ArgumentError)
  end

  it "throws exception when a negative value is used to update the width field" do
    expect{@image_data.width = -3}.to raise_error(ArgumentError)
  end

  it "allows to change the actual height field" do
    @image_data.height = 5
    expect(@image_data.height).to eql(5)
  end

  it "throws exception when something other than a Fixnum is used to update the height field" do
    expect{@image_data.height = "5"}.to raise_error(ArgumentError)
  end

  it "throws exception when a negative value is used to update the height field" do
    expect{@image_data.height = -3}.to raise_error(ArgumentError)
  end

  it "has a blank data creator" do
    data = RubyPager::Image_Data.blank_data()
    expect(data["@imageFilename"]).to eql("") and expect(data["@imageWidth"]).to eql("0") and expect(data["@imageHeight"]).to eql("0")
  end

  it "consolidates correctly and gives back updated data in original format" do
    @image_data.file_name="evidal.jpg"
    @image_data.width = 3
    @image_data.height = 5
    data= @image_data.get_consolidated_data
    expect(data["@imageFilename"]).to eql("evidal.jpg") and expect(data["@imageWidth"]).to eql("3") and expect(data["@imageHeight"]).to eql("5")
  end


end


RSpec.describe RubyPager::Text_Region , :type => :aruba do
  let(:test_file){ './test.xml'}
  let(:out_page_file){'./page.xml'}
  before{@region=RubyPager::Page.load_from_xml(test_file)["TextRegion_1507554599035_50"];}

  it "allows access to the text region id" do
    expect(@region.id).not_to be_nil
  end

  it "allows to change the actual region id" do
    @region.id = "region_x"
    expect(@region.id).to eql("region_x")
  end

  it "throws exception when something other than a string is used to update the id" do
    expect{@region.id = 100}.to raise_error(ArgumentError)
  end

  it "allows to change the order index" do
    @region.index = 100
    expect(@region.index).to eql(100)
  end

  it "throws exception when something other than a positive integer is used to update the order index" do
    expect{@region.index = -1}.to raise_error(ArgumentError)
  end

  it "allows access to the custom field" do
    expect(@region.custom).not_to be_nil

  end

  it "allows access to the region contour" do
    expect(@region.contour.size).not_to be_nil
  end

  it "allows access to the underlying text lines" do
    expect(@region["line_0"].id).to eql("line_0")
  end

  it "allows to clear all lines in the region" do
    @region.clear_text_lines
    expect(@region.size).to eql(0)
  end

  it "allows to ask for the lines it contains by id" do
    expect(@region.has_line? "line_test").to eql(false) and expect(@region.has_line? "line_0").to eql(true)
  end

  it "allows to add text lines to the region" do
    line = RubyPager::Text_Line.new(0,RubyPager::Text_Line.blank_data)
    line.id="line_test"
    past_size=@region.size
    @region.push(line)
    expect(@region.size).to eql(past_size+1) and expect(@region.has_line? "line_test").to eql(true)
  end

  it "throws exception when something other a text line is tried to be added to the region" do
    expect{@region.push(1)}.to raise_error(ArgumentError)
  end

  it "consolidates correctly and gives back updated data in original format" do
    line = RubyPager::Text_Line.new(0,RubyPager::Text_Line.blank_data)
    line.id="line_test"
    @region.push(line)
    @region.id="region_test"
    data = @region.get_consolidated_data
    expect(data["@id"]).to eql("region_test") and expect(data["TextLine"].last["@id"]).to eql("line_test")
  end

  it "has a blank data creator" do
    data = RubyPager::Text_Region.blank_data()
    expect(data["Coords"]["@points"]).to eql("") and expect(data["@custom"]).to eql("") and expect(data["@id"]).to eql("") and expect(data["TextLine"].class).to eql(Array)
  end

  it "has a blank object creator" do
    blank_tr=RubyPager::Text_Region.blank
    expect(blank_tr.index).to eql(0) and expect(blank_tr.id).to eql("") and expect(blank_tr.custom).to eql("") and expect(blank_tr.size).to eql(0)
  end

end

RSpec.describe RubyPager::Text_Line , :type => :aruba do
  let(:test_file){ './test.xml'}
  let(:out_page_file){'./page.xml'}
  before{@line=RubyPager::Page.load_from_xml(test_file)["TextRegion_1507554599035_50"]["line_0"];}

  it "allows access to the text line id" do
    expect(@line.id).not_to be_nil
  end

  it "allows to change the actual line id" do
    @line.id = "line_x"
    expect(@line.id).to eql("line_x")
  end

  it "throws exception when something other than a string is used to update the id" do
    expect{@line.id = 100}.to raise_error(ArgumentError)
  end

  it "allows to change the order index" do
    @line.index = 100
    expect(@line.index).to eql(100)
  end

  it "throws exception when something other than a positive integer is used to update the order index" do
    expect{@line.index = -1}.to raise_error(ArgumentError)
  end

  it "allows access to the actual text inside the text line" do
    expect(@line.text).not_to be_nil
  end

  it "allows to change the actual text present in the line" do
    @line.text = "hola"
    expect(@line.text).to eql("hola")
  end

  it "throws exception when something other than a string is used to update the text" do
    expect{@line.text = 2}.to raise_error(ArgumentError)
  end

  it "allows access to its contour" do
    expect(@line.contour).not_to be_nil

  end

  it "consolidates correctly and gives back updated data in original format" do
    @line.contour.push(RubyPager::Coord.new(4,"7,8"))
    @line.contour[0].y=2
    @line.text="hola"
    @line.id="line_x"
    data = @line.get_consolidated_data
    expect(data["Coords"]["@points"]).to eql("16,2 305,0 305,112 16,112 7,8") and expect(data["TextEquiv"]["Unicode"]).to eql("hola") and expect(data["@id"]).to eql("line_x")
  end

  it "has a blank data creator" do
    data = RubyPager::Text_Line.blank_data()
    expect(data["Coords"]["@points"]).to eql("") and expect(data["TextEquiv"]["Unicode"]).to eql("") and expect(data["@id"]).to eql("")
  end

  it "has a blank object creator" do
    blank_tl=RubyPager::Text_Line.blank
    expect(blank_tl.index).to eql(0) and expect(blank_tl.id).to eql("") and expect(blank_tl.text).to eql("")
  end

end

RSpec.describe RubyPager::Coords, :type => :aruba do
  before{@coords=RubyPager::Coords.new("1,2 3,4 5,6")}

  it "allows access to the underlying points" do
    expect(@coords[0].id).to eql(0)
  end
  it "throws exception when accessing a non existing point possition" do
    expect{@coords[-1]}.to raise_error(RangeError)
  end

  it "processes the correct number of points" do
    expect(@coords.size).to eql(3)
  end


  it "allows points to be added" do
    @coords.push(RubyPager::Coord.new(4,"7,8"))
    expect(@coords.size).to eql(4)
  end
  it "throws exception when something other than a coord is added" do
    expect{@coords.push(2)}.to raise_error(ArgumentError)
  end
  it "consolidates correctly and give back updated data in original format" do
    @coords.push(RubyPager::Coord.new(4,"7,8"))
    @coords[0].x=2
    expect(@coords.get_consolidated_data).to eql("2,2 3,4 5,6 7,8")
  end

  it "allows points to be deleted" do
    @coords.delete(1)
    expect(@coords.get_consolidated_data).to eql("1,2 5,6")
  end

  it "has a blank data creator" do
    data = RubyPager::Coords.blank_data()
    expect(data).to eql("")
  end

  it "has a blank object creator" do
    blank_coords=RubyPager::Coords.blank
    expect(blank_coords.size).to eql(0) and expect(blank_coords.get_consolidated_data).to eql("")
  end

end

RSpec.describe RubyPager::Coord, :type => :aruba do
  before{@coord=RubyPager::Coord.new(1,"10,15")}
  it "allows access to its possition id" do
    expect(@coord.id).to eql(1)
  end

  it "allow to update the coord values" do
    @coord.x=2
    @coord.y=3
    expect(@coord.x).to eql(2) and expect(@coord.y).to eql(3)
  end
  it "allow to update the id values" do
    @coord.id=100
    expect(@coord.id).to eql(100)
  end

  it "throws exception when id is updated with negative value " do
    expect{@coord.id=-2}.to raise_error(StandardError)
  end

  it "throws exception when X coord is updated with negative value " do
    expect{@coord.x=-2}.to raise_error(StandardError)
  end

  it "throws exception when Y coord is updated with negative value " do
    expect{@coord.y=-2}.to raise_error(StandardError)
  end

  it "proccess correctly the data string" do
    expect(@coord.x).to eql(10) and expect(@coord.y).to eql(15)
  end

  it "throws exception when passed incorrect coord data" do
    expect{RubyPager::Coord.new(1,"10,")}.to raise_error(StandardError)
  end

  it "consolidates correctly and give back updated data in original format" do
    @coord.x=2
    @coord.y=3
    expect(@coord.get_consolidated_data).to eql("2,3")
  end

end
