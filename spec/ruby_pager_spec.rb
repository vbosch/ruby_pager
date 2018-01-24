
RSpec.describe RubyPager do
  it "has a version number" do
    expect(RubyPager::VERSION).not_to be nil
  end

  it "XML checks file exists" do
    expect(RubyPager::XML.exists?("test.xml")).to eql(true)
  end

  it "XML provides hash of loaded file" do
    expect(RubyPager::XML.load("test.xml")).to be_a(Hash)
  end

  it "XML provides nil when loading incorrect/inexistent file" do
    expect(RubyPager::XML.load("doesnotexist.xml")).to be_nil
  end
end
