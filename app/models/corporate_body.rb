class CorporateBody < Neo4j::Rails::Model
  include Tire::Model::Search
  include Tire::Model::Callbacks
  index :id
  
  property :name, :type => String, :index => :exact
  has_n(:is_part_of).to(CorporateBody)
  has_n(:members).from(Person, :has_member)
end
