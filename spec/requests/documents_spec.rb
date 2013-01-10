require 'spec_helper'

describe "Documents" do
  describe "GET /documents" do
    it "works! (now write some real specs)" do
      #
      Document.tire.index.delete
      Document.create!
      #Document.tire.index.create
      Document.all.each{ |d| d.save }
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get documents_path
      response.status.should be(200)
      Document.tire.index.delete
    end
  end
end
