require 'spec_helper'

describe "corporate_bodies/index" do
  before(:each) do
    assign(:corporate_bodies, [
      stub_model(CorporateBody,
        :name => "Name"
      ),
      stub_model(CorporateBody,
        :name => "Name"
      )
    ])
  end

  it "renders a list of corporate_bodies" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
