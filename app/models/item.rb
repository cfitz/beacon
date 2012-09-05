require 'iconv'
class Item < Neo4j::Rails::Model
  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Neo4jrb::Paperclip
  index :id
   
  before_save :default_values
  validates :document, :presence => true
  
  
  property :uri, :type => String
  property :item_type, :type => String, :index => :exact

  property :parent_uuid, :type => String 

  property :created_at, :type => DateTime
  index :created_at

  property :updated_at, :type => DateTime
  index :updated_at

  property :open_access, :type => :boolean
  property :pages

  has_one(:document).from(Document, :items)
  has_neo4jrb_attached_file :attachment
  
  before_post_process :transliterate_file_name
  
  
  def default_values
    self.open_access = false
    self.uri = self.attachment.url if self.uri.blank? 
    self.parent_uuid ||= self.document.uuid 
  end
  
  def url
   self.attachment.exists? ? self.attachment.url : self.uri
  end
 
  def authenticated_s3_get_url(base_path = attachment.path,  options={})
     options.reverse_merge! :expires_in => 10.minutes, :use_ssl => true
     AWS::S3::S3Object.url_for base_path, attachment.options[:bucket], options
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
    self.open_access ? 
    self.open_access : false
  end
  
  def basedir
    self.url.gsub(self.url.split("/").last, "").chomp("/")
  end
  
  
  def to_document_json
    {
       "title" => self.document.title,
       "description" =>   self.document.summary,
       "id" => self.document.id,
       "pages" => self.pages,
        "annotations" => [], 
        "sections" => [],
       "resources" => {
         "page" => { 
           "text" => authenticated_s3_get_url("#{self.basedir}/text/{page}.txt") , 
           "image" => authenticated_s3_get_url("#{self.basedir}/images/{size}/{page}.png") },
         "pdf"  =>  authenticated_s3_get_url,
         "search" => "http://"
       }
     }.to_json
    
  end
  
  # uses ApplicationHelpers transliterate method to clean filenames
  def transliterate_file_name
    extension = File.extname(attachment_file_name).gsub(/^\.+/, '')
    filename = attachment_file_name.gsub(/\.#{extension}$/, '')
    self.attachment.instance_write(:file_name, "#{transliterate(filename)}.#{transliterate(extension)}")
  end
  
  # this is used to convert weird file names into plain url friend ones. See Item model for example usages
   def transliterate(str)
     s = Iconv.iconv('ascii//ignore//translit', 'utf-8', str).to_s
     s.downcase!
     s.gsub!(/'/, '')
     s.gsub!(/[^A-Za-z0-9]+/, ' ')
     s.strip!
     s.gsub!(/\ +/, '-')
     return s
   end

  
  

end
