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
  before{@page=RubyPager::Page.new(test_file);}
  it "allows access to file name" do
    expect(@page.file_name).to eql(test_file)
  end

  it "gives access to the text regions inside" do
    expect(@page.text_regions).not_to be_nil
  end


end
