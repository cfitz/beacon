class CorporateBody < Neo4j::Rails::Model
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index :id
  
  property :name, :type => String, :index => :exact

end
