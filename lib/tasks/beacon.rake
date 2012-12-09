require 'lib/document_importer'
require 'lib/person_importer'
require 'lib/document_indexer'
require 'lib/places_importer'
namespace :beacon do
  namespace :import do
    
    task :documents  => :environment do 
      di = DocumentImporter.new
      di.process
      true
    end
    
    task :people  => :environment do 
      pi = PersonImporter.new
      pi.process
      true
    end
    
    task :index => :environment do
      di = DocumentIndexer.new
      di.index
    end
    
    task :places => :environment do
        PlacesImporter.process
    end
    
    
    task :all  => :environment do 
      Rake::Task["beacon:import:places"].invoke
      Rake::Task["beacon:import:people"].invoke
      Rake::Task["beacon:import:documents"].invoke
      Rake::Task["beacon:import:index"].invoke

    end
    
  end
end
