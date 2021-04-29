ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'

require_relative 'test_load_all'

def wipe_database
  app.DB[:pets].delete
  app.DB[:habits].delete
end

DATA = {} # rubocop:disable Style/MutableConstant
DATA[:pets] = YAML.safe_load File.read('app/db/seeds/pet_seeds.yml')
DATA[:habits] = YAML.safe_load File.read('app/db/seeds/habit_seeds.yml')