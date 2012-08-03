require 'spec_helper'

describe "concepts/new" do
  before(:each) do
    assign(:concept, stub_model(Concept,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new concept form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => concepts_path, :method => "post" do
      assert_select "input#concept_name", :name => "concept[name]"
    end
  end
end
