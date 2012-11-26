class Event < Neo4j::Rails::Model
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Sluggable
  index :id
  
  property :name, :type => String, :index => :exact
  property :slug, :index => :exact
  property :created_at, :type => DateTime
  index :created_at

  property :updated_at, :type => DateTime
  index :updated_at
  validates :name, :presence => true
  validate :ensure_named, :before => :create
  
  
  mapping do
      indexes :name, analyzer: 'snowball', boost: 100
  end

end
