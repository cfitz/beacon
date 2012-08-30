#ties a person to a corporate_body
class GroupMember < Neo4j::Rails::Relationship
  property :member_type, :index => :exact
end