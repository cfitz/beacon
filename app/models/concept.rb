class Concept < Neo4j::Rails::Model
  include Tire::Model::Search
  include Tire::Model::Callbacks
  property :name, :type => String, :index => :exact

end
