require 'spec_helper'

describe "corporate_bodies/edit" do
  before(:each) do
    @corporate_body = assign(:corporate_body, stub_model(CorporateBody,
      :name => "MyString"
    ))
  end

  it "renders the edit corporate_body form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => corporate_bodies_path(@corporate_body), :method => "post" do
      assert_select "input#corporate_body_name", :name => "corporate_body[name]"
    end
  end
end
