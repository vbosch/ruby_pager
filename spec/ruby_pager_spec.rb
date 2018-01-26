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

RSpec.describe RubyPager::Text_Region , :type => :aruba do
  let(:test_file){ './test.xml'}
  let(:out_page_file){'./page.xml'}
  before{@page=RubyPager::Page.new(test_file);}

end