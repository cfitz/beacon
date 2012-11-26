class Place < Neo4j::Rails::Model
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Sluggable
  
  index :id
  
  property :name, :type => String, :index => :exact
  property :slug, :index => :exact
  property :place_type, :type => String, :index => :exact
  
  has_n(:members).from(Person, :has_nationality)
  validates :name, :presence => true
  validate :ensure_named, :before => :create
 
  mapping do
      indexes :name, analyzer: 'snowball', boost: 100
  end

end
