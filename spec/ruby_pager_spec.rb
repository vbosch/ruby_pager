
RSpec.describe RubyPager do
  it "has a version number" do
    expect(RubyPager::VERSION).not_to be nil
  end

  it "XML checks file exists" do
    expect(RubyPager::XML.exists?("test.xml")).to eql(true)
  end
end
