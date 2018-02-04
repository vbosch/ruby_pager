require 'aruba/rspec'

RSpec.describe Utils::Image , :type => :aruba do
  let(:test_image){ './test.jpg'}
  before{@image=Utils::Image.new(test_image)}
  it "allows you to isplay the image loaded" do
    expect(@image.display).not_to be nil
  end

end