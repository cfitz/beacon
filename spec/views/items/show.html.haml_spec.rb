require 'spec_helper'

describe "items/show" do
  before(:each) do
    @item = assign(:item, 
       Factory.create(:item)
      )
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyURI/)
    rendered.should match(/MyFormat/)
  end
end
