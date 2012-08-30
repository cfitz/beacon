class Event < Neo4j::Rails::Model
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index :id
  
  property :name, :type => String, :index => :exact

  property :created_at, :type => DateTime
  index :created_at

  property :updated_at, :type => DateTime
  index :updated_at
  

end
