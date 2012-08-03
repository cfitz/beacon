namespace :db do
  namespace :test do
    task :prepare do
      rm_rf "db/neo4j-test" if File.exist?("db/neo4j-test")
    end
  end
end
