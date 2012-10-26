class Item < Neo4j::Rails::Model
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Rails.application.routes.url_helpers
     
  validates :document, :presence => true
  validates :url, :presence => true
  
  index :id
  
  
  property :url, :type => String
  property :item_type, :type => String, :index => :exact

  property :resource_id, :type => String 

  property :created_at, :type => DateTime
  index :created_at

  property :updated_at, :type => DateTime
  index :updated_at

  property :pages

  has_one(:document).from(Document, :items)
  
  def embed
    "<iframe src='#{self.url.gsub("edit", "preview")}'></iframe>".html_safe
  end
  
  
  def name
    self.item_type.empty? ? "View Document" : self.item_type
  end

  def title
    self.document.title ? self.document.title : "Unknown"
  end 

  def summary
    self.document.summary ? self.document.summary : ""
  end

  def _destroy
    false
  end

  def public?
   true
  end
  
  def basedir
    self.url.gsub(self.url.split("/").last, "").chomp("/")
  end
  
end
