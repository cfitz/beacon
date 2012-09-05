class Topic < Neo4j::Rails::Model

  property :name, :type => String, :index => :fulltext
  has_n(:documents).from(:Document, :topics )
  has_n(:terms)

  property :created_at, :type => DateTime
   index :created_at
   property :updated_at, :type => DateTime
   index :updated_at





  def _destroy 
    false
  end


end
