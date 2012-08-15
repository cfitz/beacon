class Person < Neo4j::Rails::Model
  
  include Tire::Model::Search
  include Tire::Model::Callbacks
  
  index :id
  
  property :name, :type => String, :index => :fulltext
  property :title, :type => String, :index => :exact

  property :surname, :type => String, :index => :exact
  property :first_name, :type => String, :index => :exact

  property :created_at, :type => DateTime
  index :created_at

  property :updated_at, :type => DateTime
  index :updated_at



  has_n(:created_work).to(Document).relationship(Creator)


  def _destroy 
    false
  end
  
 def _new
   false
 end
 

end
