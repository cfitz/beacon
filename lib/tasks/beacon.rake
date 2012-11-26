require 'lib/document_importer'
require 'lib/person_importer'
require 'lib/document_indexer'

namespace :beacon do
  namespace :import do
    
    task :documents  => :environment do 
      di = DocumentImporter.new
      di.process
    end
    
    task :people  => :environment do 
      pi = PersonImporter.new
      pi.process
    end
    
    task :index => :environment do
      di = DocumentIndexer.new
      di.index
    end
    
    task :all  => :environment do 
      Rake::Task["beacon:import:documents"].invoke
      Rake::Task["beacon:import:people"].invoke
      Rake::Task["beacon:import:index"].invoke

    end
    
  end
end
