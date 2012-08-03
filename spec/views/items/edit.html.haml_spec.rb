require 'spec_helper'

describe "items/edit" do
  before(:each) do
    @item = assign(:item, Factory.create(:item) )
  end

  it "renders the edit item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => items_path(@item), :method => "post" do
      assert_select "input#item_uri", :name => "item[uri]"
      assert_select "input#item_format", :name => "item[format]"
    end
  end
end
