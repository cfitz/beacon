
# simple hack to ensure ElasticSearch has an index ready for the model.

[ Document, Person, Place, CorporateBody, Topic ].each do |k|  
      if k.send(:all).to_a.length < 1
        "No objects found for #{k}. Creating index."
        index = Tire::Index.new(k.send(:index_name))
        index.delete if index.exists?
        m = k.send(:create, {:name => "foo"})
        m.delete
      end
end
