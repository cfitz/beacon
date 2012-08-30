class Document < Neo4j::Rails::Model

  include Tire::Model::Search
  include Tire::Model::Callbacks
  include Neo4jrb::Paperclip
  include BeaconSearch
  
  index :id
  
  property :title, :type => String, :index => :exact
  property :date, :type => String, :index => :exact
  property :uuid, :type => String
  property :summary, :type => String, :index => :exact
  

  property :created_at, :type => DateTime
  index :created_at
  property :updated_at, :type => DateTime
  index :updated_at



  has_n(:creators).from(:Person, :created_work )
  has_n(:items).to(Item).relationship(WorkItem)
  has_n(:pages).from(:Page)
  has_n(:sections).from(:Section)
  has_n(:annotations).from(:Annotation)
  
  has_n(:topics).from(:Topic)
  
  accepts_nested_attributes_for :creators, :allow_destroy_relationship => true, :reject_if => proc { |attributes| attributes['id'].blank? && attributes['name'].blank? }
  accepts_nested_attributes_for :items
  
  def self.facets
      [ :format ]
  end

 
  mapping do
      indexes :topics, :type => 'string'
      indexes :topic_facets, :type => 'string', :index => :not_analyzed
  end

  
  # this configures how tire indexs into Elastic Search
  def to_indexed_json
         json = {
            :title   => title,
            :summary => summary,
            :topic_facets => topics.collect { |t| t.name },
            :creators => creators.collect { |c| c.name },
            :topics => topics.collect { |t| t.name },
            :format => items.collect { |i| i.item_type },
            :items => items.collect { |i| i.url }
          }
          json[:date] = date if date
          json.to_json
  end
  
  

  
  
  
  # this is a fix for rails that allows us to destroy relationships without destroying the item.
   def update_nested_attributes(rel_type, attr, options)
      allow_destroy, allow_destroy_relationship, reject_if = [options[:allow_destroy], options[:allow_destroy_relationship], options[:reject_if]] if options
      begin
        # Check if we want to destroy not found nodes (e.g. {..., :_destroy => '1' } ?
        destroy = attr.delete(:_destroy)
        destroy = '0' if destroy == 'false'
        found = _find_node(rel_type, attr[:id]) || Neo4j::Rails::Model.find(attr[:id])
        if allow_destroy && destroy && destroy != '0'
          found.destroy if found
        elsif allow_destroy_relationship && destroy && destroy != '0'
          _remove_relationship(rel_type, found) if found
        else
          if not found
            _create_entity(rel_type, attr) #Create new node from scratch
          else
            #Create relationship to existing node in case it doesn't exist already
            _add_relationship(rel_type, found) if (not _has_relationship(rel_type, attr[:id]))
            found.update_attributes(attr)
          end
        end
      end unless reject_if?(reject_if, attr)
    end
    
    def _remove_relationship(rel_type, node)
      if respond_to?("#{rel_type}_rel")
        send("#{rel_type}=", nil)
      elsif respond_to?("#{rel_type}_rels")
        has_n = send("#{rel_type}")
        has_n.delete( node )
      else
        raise "oops #{rel_type}"
      end
    end


  def name
    self.title
  end
  
  def available_formats
    formats = self.items.collect {|i| i.item_type }
    return formats.compact!
  end
  
  
  def prepare!
      self.uuid ||= SecureRandom.urlsafe_base64
      self.title ||= "Untitled Document"
      self.items.build
      self
  end


end
