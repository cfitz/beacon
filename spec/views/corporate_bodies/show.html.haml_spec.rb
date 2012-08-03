require 'spec_helper'

describe "corporate_bodies/show" do
  before(:each) do
    @corporate_body = assign(:corporate_body, stub_model(CorporateBody,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
