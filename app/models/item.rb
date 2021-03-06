class Item < Neo4j::Rails::Model
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Neo4jrb::Paperclip
   index :id
   
  before_save { |record| record.uri = record.attachment.url if record.uri.blank?  }
   
  
  property :parent_uuid, :type => String
  
  property :uri, :type => String
  property :item_type, :type => String, :index => :exact

  property :created_at, :type => DateTime
  index :created_at

  property :updated_at, :type => DateTime
  index :updated_at


  has_one(:document).from(Document, :items)
  has_neo4jrb_attached_file :attachment
  

  
  def name
    self.format.empty? ? "View Document" : self.format
  end

  def _destroy
    false
  end


end
