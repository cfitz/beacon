class Place < Neo4j::Rails::Model
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include BeaconSearch
  include Sluggable
  
  index :id
  
  property :name, :type => String, :index => :exact
  property :slug, :index => :exact
  property :place_type, :type => String, :index => :exact
  property :iso_code, :type => String
  
  has_n(:documents).from(:Document, :topics )
  has_n(:members).from(Person, :has_nationality)
  
  has_n(:has_locations).to(:Place)
  has_n(:located_in).from(:Place, :has_locations)
  
  has_n(:aliases).to(Term).relationship(Alias)
  
  validates :name, :presence => true
  validate :ensure_named, :before => :create
 
  mapping do
      indexes :name, analyzer: 'snowball', boost: 1000
      indexes :name_sort, :type => "string", :index => "not_analyzed"
      indexes :slug, :type => "string", :index => "not_analyzed" # use the slug for name sorting
      indexes :continent_facet, :type => "string", :index => "not_analyzed"
      indexes :place_type_facet, :type => "string", :index => "not_analyzed"
  end
  
  def self.facets
    [ :continent_facet, :place_type_facet ]
  end

  # this configures how tire indexs into Elastic Search
  def to_indexed_json
         json = {
            :name   => name,  
            :name_sort => name,
            :continent_facet => self.belongs_to_continents,
            :place_type_facet => self.place_type
          }
          json.to_json
  end
  
  
  def belongs_to_continents
    continents = []
    self.located_in.each { |c| continents << c.name if c.place_type == "continent" }
    continents
  end


end
