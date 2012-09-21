class CorporateBody < Neo4j::Rails::Model
  
  before_save :index_exact_name
  
      
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index :id
  
  property :name, :type => String, :index => :fulltext
  property :exact_name, :type => String, :index => :exact
  has_n(:is_part_of).to(CorporateBody)
  has_n(:members).from(Person, :has_member)
  has_n(:created_work).to(Document).relationship(Creator)
  
  def _destroy 
     false
   end

  def _new
    false
  end
  

   private

  # this is a simple method to make sure we're fulltext and extact indexing hte name. this helps with finders. 
  # if there's a name or it changes, we add match exact_name to it. If there's not a name, assume it's being created
  # by CorporateBody.find_or_create_by(:exact_name => "Foobar"), so we match the name to it. 
  def index_exact_name
    if self.name.blank?
      self.name = self.exact_name
    else
      self.exact_name = self.name 
    end
  end




end
