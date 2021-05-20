# frozen_string_literal: true

require 'rake/testtask'

task :default => :spec

desc 'Tests API specs only'
task :api_spec do
  sh 'ruby spec/api_spec.rb'
end

desc 'Test all the specs (tests)'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

desc 'Runs rubocop on tested code'
task :style => [:spec, :audit] do
  sh 'rubocop .'
end

desc 'Update vulnerabilities lit and audit gems'
task :audit do
  sh 'bundle audit check --update'
end

desc 'Checks for release'
task :release? => [:spec, :style, :audit] do
  puts "\nReady for release!"
end

task :print_env do
  puts "Environment: #{ENV['RACK_ENV'] || 'development'}"
end

desc 'Run application console (pry)'
task :console => :print_env do
  sh 'pry -r ./spec/test_load_all'
end

namespace :db do
   require_relative 'config/environments' # load config info
   require 'sequel'

   #Check names
   Sequel.extension :migration
   app = Pets_Tinder::Api

   desc 'Run migrations'
   task :migrate => :print_env do
    puts 'Migrating database to latest'
    Sequel::Migrator.run(app.DB, 'app/db/migrations')
   end

   desc 'Delete database'
   task :delete do
    app.DB[:pets].delete
   end

   desc 'Delete dev or test database file'
   task :drop do
    if app.environment == :production
      puts 'Cannot wipe production database!'
      return
    end

    # Please check db names
    db_filename = "app/db/store/#{Pets_Tinder::Api.environment}.db"
    FileUtils.rm(db_filename)
    puts "Deleted #{db_filename}"
   end

   desc 'Delete and migrate again'
   task reset: [:drop, :migrate]

  end   

  #We can use this rake to create new keys for dev, test, prod (we can have different ones)
  namespace :newkey do
    desc 'Create sample cryptographic key for database'
    task :db do
      require_app('lib')
      puts "DB_KEY: #{SecureDB.generate_key}"
    end
  namespace :run do
    # Run in development mode
    task :dev do
      sh 'rackup -p 3000'
    end
  end

end