class Place < Neo4j::Rails::Model
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include BeaconSearch
  include Sluggable
  
  index :id
  
  property :name, :type => String, :index => :exact
  property :slug, :index => :exact
  property :place_type, :type => String, :index => :exact
  
  has_n(:documents).from(:Document, :topics )
  has_n(:members).from(Person, :has_nationality)
  
  
  validates :name, :presence => true
  validate :ensure_named, :before => :create
 
  mapping do
      indexes :name, analyzer: 'snowball', boost: 1000
      indexes :slug, :type => "string", :index => "not_analyzed" # use the slug for name sorting
  end
  
  def self.facets
    []
  end

end
