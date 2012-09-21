class Person < Neo4j::Rails::Model
  
  before_save :index_exact_name
  
  include Tire::Model::Search
  include Tire::Model::Callbacks
  
  index :id
  
  
  property :name, :type => String, :index => :fulltext
  property :exact_name, :type => String, :index => :exact # this is to help us find the name
  property :title, :type => String, :index => :exact
  
  property :alt_id, :type => String, :index => :exact

  property :surname, :type => String, :index => :exact
  property :first_name, :type => String, :index => :exact

  property :created_at, :type => DateTime
  index :created_at

  property :updated_at, :type => DateTime
  index :updated_at
  
  property :person_type, :type => String, :index => :exact



  has_n(:documents_created).from(Document.creators).relationship(Creator)
  has_n(:has_membership).to(CorporateBody).relationship(GroupMember)
  
  mapping do
       indexes :name,  :analyzer => 'snowball', :boost => 100
  end



  def _destroy 
    false
  end
  
 def _new
   false
 end


 
 
 private
 
 def index_exact_name
    if self.name.blank?
      self.name = self.exact_name
    else
      self.exact_name = self.name 
    end
  end
  
end
