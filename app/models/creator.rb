class Creator < Neo4j::Rails::Relationship
  property :title, :role, :index => :exact
  
  DEFAULT_ROLES = [ "author", "editor" ]
  
  # this take the roles and returns an array that can be used in the form helper
  # [ ["Author", "author"], ["Editor", "editor" ]]
  def possible_roles
    ([self.role] + DEFAULT_ROLES).uniq.compact.collect { |r| [ r.titleize, r ]}
  end
  
  
  # class method to format the roles, similar to #possible_roles
  def self.default_roles
    DEFAULT_ROLES.collect { |r| [ r.titleize, r ]}
  end
  
end