ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'

require_relative 'test_load_all'

def wipe_database
  app.DB[:pets].delete
  app.DB[:habits].delete
  app.DB[:accounts].delete
end


DATA = {
  accounts: YAML.load(File.read('app/db/seeds/accounts_seed.yml')),
  habits: YAML.load(File.read('app/db/seeds/habit_seeds.yml')),
  pets: YAML.load(File.read('app/db/seeds/pet_seeds.yml'))
}.freeze