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

  it "gives access to the text regions inside" do
    expect(@page.text_regions).not_to be_nil
  end

  it "saves contents a PAGE xml file" do
    @page.save(out_page_file)
    check=File.exists?(out_page_file)
    expect(check).to eql(true)
  end

  it "loads the correct number of text regions" do
    external_count=`cat test.xml | grep '<TextRegion' | wc -l`.to_i
    expect(@page.text_regions.size).to eql(external_count)
  end

end

RSpec.describe RubyPager::Text_Region , :type => :aruba do
  let(:test_file){ './test.xml'}
  let(:out_page_file){'./page.xml'}
  before{@page=RubyPager::Page.new(test_file);}

  it "allows access to the text region id" do
    expect(@page.text_regions.values[0].id).not_to be_nil
  end

  it "allows access to the custom field" do
    expect(@page.text_regions.values[0].custom).not_to be_nil

  end

  it "allows access to the underlying text lines" do
    expect(@page.text_regions.values[0].text_lines).not_to be_nil

  end

end

RSpec.describe RubyPager::Text_Line , :type => :aruba do
  let(:test_file){ './test.xml'}
  let(:out_page_file){'./page.xml'}
  before{@line=RubyPager::Page.new(test_file).text_regions.values[0].text_lines.values[0];}

  it "allows access to the text line id" do
    expect(@line.id).not_to be_nil
  end

  it "allows access to the actual text inside the text line" do
    expect(@line.text).not_to be_nil
  end

  it "allows access to its contour" do
    expect(@line.contour).not_to be_nil

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
