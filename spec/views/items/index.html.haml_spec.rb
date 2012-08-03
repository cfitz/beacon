require 'spec_helper'

describe "items/index" do
  before(:each) do
    assign(:items, [
      Factory.create(:item), Factory.create(:item)
    ])
  end

  it "renders a list of items" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyURI".to_s, :count => 2
    assert_select "tr>td", :text => "MyFormat".to_s, :count => 2
  end
end
