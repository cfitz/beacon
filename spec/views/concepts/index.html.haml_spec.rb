require 'spec_helper'

describe "concepts/index" do
  before(:each) do
    assign(:concepts, [
      stub_model(Concept,
        :name => "Name"
      ),
      stub_model(Concept,
        :name => "Name"
      )
    ])
  end

  it "renders a list of concepts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
