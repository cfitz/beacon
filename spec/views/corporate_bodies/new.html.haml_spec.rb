require 'spec_helper'

describe "corporate_bodies/new" do
  before(:each) do
    assign(:corporate_body, stub_model(CorporateBody,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new corporate_body form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => corporate_bodies_path, :method => "post" do
      assert_select "input#corporate_body_name", :name => "corporate_body[name]"
    end
  end
end
