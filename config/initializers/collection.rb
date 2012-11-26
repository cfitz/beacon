# Neo4jrb #find does not like the process arrays. This replaces that with a Cyper query. 
module Tire
  module Results

    class Collection
    
    
          def __find_records_by_ids(klass, ids)
                @options[:load] === true ? Neo4j.query {  n = node(ids); n }.collect { |n| n[:v1] } : klass.find(ids, @options[:load])
          end

    end
  end
end
