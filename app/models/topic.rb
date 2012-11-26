# a topic is a combinate of things, places, people, concepts that can be applied to documents. 
# for example "Malmö Shipbuilding in the 20th Century" has place (malmo), concept (shipbuilding), and date (20th century).
# all these terms will be tied together to form a topic. 
class Topic < Neo4j::Rails::Model
  include Sluggable

  property :name, :type => String, :index => :fulltext
  property :slug, :index => :exact
  
  has_n(:documents).from(:Document, :topics )
  has_n(:terms)

  property :created_at, :type => DateTime
  index :created_at
  property :updated_at, :type => DateTime
  index :updated_at

  validates :name, :presence => true
  validate :ensure_named, :before => :create


# We are currently not indexing topics...
#  mapping do
#      indexes :name, analyzer: 'snowball', boost: 100
#  end



  def _destroy 
    false
  end


end
