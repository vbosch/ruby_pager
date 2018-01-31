require 'aruba/rspec'

RSpec.describe RubyPager::XML , :type => :aruba do
  let(:test_file){ './test.xml'}
  let(:out_file){ './output.xml'}
  before{@data=RubyPager::XML.load(test_file);RubyPager::XML.save(out_file,@data);}
  subject{@data}
  it "has a version number" do
    expect(RubyPager::VERSION).not_to be nil
  end

  it "checks file exists" do
    expect(RubyPager::XML.exists?(test_file)).to eql(true)
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
  before{@page=RubyPager::Page.new(test_file);}

  it "allows access to file name" do
    expect(@page.file_name).to eql(test_file)
  end

  it "allows access to the metadata" do
    expect(@page.metadata.class).to eql(RubyPager::Metadata)
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

end


RSpec.describe RubyPager::Metadata , :type => :aruba do
  let(:test_file){ './test.xml'}
  before{@metadata=RubyPager::Page.new(test_file).metadata}
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
    expect(data["Creator"]).to eql("") and expect(data["Created"]).to eql("") and expect(data["LastChange"]).to eql("")
  end


  it "consolidates correctly and gives back updated data in original format" do
    @metadata.creator="Enrique Vidal"
    data= @metadata.get_consolidated_data
    expect(data["Creator"]).to eql("Enrique Vidal")
  end
end


RSpec.describe RubyPager::Text_Region , :type => :aruba do
  let(:test_file){ './test.xml'}
  let(:out_page_file){'./page.xml'}
  before{@region=RubyPager::Page.new(test_file)["TextRegion_1507554599035_50"];}

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

end

RSpec.describe RubyPager::Text_Line , :type => :aruba do
  let(:test_file){ './test.xml'}
  let(:out_page_file){'./page.xml'}
  before{@line=RubyPager::Page.new(test_file)["TextRegion_1507554599035_50"]["line_0"];}

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
