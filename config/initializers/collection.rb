module Tire
  module Results

    class Collection
    
       def results
          @results ||= begin
            hits = @response['hits']['hits'].map { |d| d.update '_type' => Utils.unescape(d['_type']) }

            unless @options[:load]
              if @wrapper == Hash
                hits
              else
                hits.map do |h|
                   document = {}

                   # Update the document with content and ID
                   document = h['_source'] ? document.update( h['_source'] || {} ) : document.update( __parse_fields__(h['fields']) )
                   document.update( {'id' => h['_id']} )

                   # Update the document with meta information
                   ['_score', '_type', '_index', '_version', 'sort', 'highlight', '_explanation'].each { |key| document.update( {key => h[key]} || {} ) }

                   # Return an instance of the "wrapper" class
                   @wrapper.new(document)
                end
              end

            else
              return [] if hits.empty?

              records = {}
              @response['hits']['hits'].group_by { |item| item['_type'] }.each do |type, items|
                raise NoMethodError, "You have tried to eager load the model instances, " +
                                     "but Tire cannot find the model class because " +
                                     "document has no _type property." unless type

                begin
                  klass = type.camelize.constantize
                rescue NameError => e
                  raise NameError, "You have tried to eager load the model instances, but " +
                                   "Tire cannot find the model class '#{type.camelize}' " +
                                   "based on _type '#{type}'.", e.backtrace
                end
                ids = items.map { |h| h['_id'] }
                records[type] = @options[:load] === true ? Neo4j.query {  n = node(ids); n }.collect { |n| n[:n0] }  : klass.find(ids, @options[:load])
              end

              # Reorder records to preserve order from search results
              @response['hits']['hits'].map { |item| records[item['_type']].detect { |record| record.id.to_s == item['_id'].to_s } }
            end
          end
        end
    
    
    
     


    end
  end
end