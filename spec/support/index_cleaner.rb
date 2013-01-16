module IndexClenaer

  def clean_indexes
    before(:each) do
      # iterate over the model types
      # there are also ways to fetch all model classes of the rails app automaticly, e.g.:
      #   http://stackoverflow.com/questions/516579/is-there-a-way-to-get-a-collection-of-all-the-models-in-your-rails-app
      [Document, Topic, Person, Place, CorporateBody, Term ].each do |klass|
        # make sure that the current model is using tire
        if klass.respond_to? :tire
          # delete the index for the current model
          klass.tire.index.delete

          # the mapping definition must get executed again. for that, we reload the model class.
          load File.expand_path("../../../app/models/#{klass.name.underscore}.rb", __FILE__)

        end
      end
    end
  end
  
end

