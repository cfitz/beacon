require 'spec_helper'

describe "items/new" do
  before(:each) do
    assign(:item, Factory.create(:item) )
  end

  it "renders new item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => items_path, :method => "post" do
      assert_select "input#item_uri", :name => "item[uri]"
      assert_select "input#item_format", :name => "item[format]"
    end
  end
end
