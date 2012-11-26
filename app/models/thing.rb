# a thing is a physical object that can be part of a topic...like "Titanic" or "Honda Civic"
class Thing < Neo4j::Rails::Model
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Sluggable
   
  index :id
   
  property :name, :type => String, :index => :exact
  property :slug, :index => :exact
  
  validates :name, :presence => true
  validate :ensure_named, :before => :create

  mapping do
      indexes :name, analyzer: 'snowball', boost: 100
  end

end
