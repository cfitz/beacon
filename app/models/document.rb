class Document < Neo4j::Rails::Model

  include BeaconSearch
  include Sluggable
  include RelationshipNestedAttributes
  
  
  validate :ensure_named, :before => :create
  before_save :default_values

  index_name "#{Tire::Model::Search.index_prefix}documents"
    
  index :id  
  property :title, :type => String, :index => :exact
  alias_attribute :name, :title
  
  attr_accessor :content # used to index full-text content
  attr_accessor :highlight # used to store the highlight content in search
  
  property :slug, :type => String, :index => :exact
  property :date, :type => String, :index => :exact
  property :uuid, :type => String
  property :summary, :type => String, :index => :exact
  
  property :created_at, :type => DateTime
  index :created_at
  property :updated_at, :type => DateTime
  index :updated_at


  has_n(:creators).relationship(Creator)  
  #.from(:Person, :created_work )
  has_n(:items).to(Item).relationship(WorkItem)
 
  has_n(:topics).to(Topic)
  
  #accepts_nested_attributes_for :creators, :allow_destroy_relationship => true, :reject_if => proc { |attributes| attributes['id'].blank? && attributes['name'].blank? }
  accepts_nested_attributes_for :items, :allow_destroy => true
  accepts_nested_attributes_for :topics, :allow_destroy_relationship => true


  def name=(name)
    self.title = name
  end
  
  def default_name
   "Untitled Document"
  end
  
  
  def default_values
    self.uuid ||= SecureRandom.urlsafe_base64
  end
  
  
  def self.facets
      [ :format_facet, :world_maritime_university_program_facet, :date, :creator_nationality_facet ]
  end


 
  mapping do
      indexes :topics, :type => 'string'
      indexes :title, analyzer: 'snowball', boost: 100
      indexes :name, analyzer: 'snowball', boost: 100
      indexes :name_sort, :type => "string", :index => "not_analyzed"
      indexes :content, analyzer: 'snowball', boost: 50
      indexes :format_facet, :type => "string", :index =>"not_analyzed"
      indexes :world_maritime_university_program_facet, :type => "string", :index => "not_analyzed"
      indexes :date, :type => "string", :index => "not_analyzed"
      indexes :creator_nationality_facet, :type => "string", :index =>"not_analyzed"

  end



  
  # this configures how tire indexs into Elastic Search
  def to_indexed_json
         json = {
            :title   => title,
            :name   => name,
            :name_sort => name,
            :content => content,
            :summary => summary,
            :topics => topics.collect { |t| t.name },
            :creators => creators.collect { |c| c.name },
            :items => items.collect { |i| i.url },
            
            :format_facet => items.collect { |i| i.item_type},
            :world_maritime_university_program_facet => programs,
            :creator_nationality_facet => creator_countries,
                        
          }
          json[:date] = date if date
          json.to_json
  end
  
  # this returns a hash of creators and roles. like: { "creator" => Person }
  def creators_by_roles
    roles_creators = {}
    self.creators_rels.each do |rel|
      role = rel.role ? rel.role : "creator"
      roles_creators[role] ||= []
      roles_creators[role] << rel.end_node
    end
    roles_creators
  end  
  
  # this returns the first item with a type of pdf. It's used to send json to document viewer 
  def pdf_item
    pdf = self.items.collect { |i| i if i.url.include?('docs.google.com') }
    pdf.first
  end
 
  #just returned title as a name. 
  def name
    self.title
  end
  
  # returns the available_formats of the document
  def available_formats
    formats = self.items.collect {|i| i.item_type }
    return formats.compact
  end
  
  # this returns an array of all the WMU program tags (MET, SPM, etc. ) related to the document. 
  # is a little odd how some of the query results are sent back....should replace w/ cypher q. 
  def programs
    programs = self.creators.to_a
    programs.collect! { |p| p.has_membership.to_a }.flatten!
    programs.collect! { |p| p.name }
    programs.uniq
  end
  
  # this returns an array of all the countries represented by the creators
  def creator_countries
    countries = self.creators.to_a
    countries.collect! { |c| c.has_nationality.to_a }.flatten!
    countries.collect! { |c| c.name }
    countries.uniq
  end

        
  # this is to fix nested attributes submitted by the form. 
  def creators_rels_attributes=(args={})
    args.each_pair do |k,v|
      destroy = v["__destroy"] == "1"
      if k.include?("new") or v["id"].empty? # this is a newly added relationship
        unless destroy
          self.save #first we need to persist the document. 
          creator = v["class"].constantize.find_or_create_by(:name => v["end_node_name"])
          creator_role = Creator.new(:creators, self, creator, {:role => v["role"] })
          creator_role.save
        end
      else # existing relationship, lets check it. 
        if destroy 
          creator = Creator.find(v["id"])
          creator.destroy 
        else
          creator = Creator.find(v["id"])
          unless creator.role == v["role"]
            creator.role = v["role"]
            creator.save
          end
        end
      end
    end
  end




end
