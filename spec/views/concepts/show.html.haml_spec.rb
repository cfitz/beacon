require 'spec_helper'

describe "concepts/show" do
  before(:each) do
    @concept = assign(:concept, stub_model(Concept,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
