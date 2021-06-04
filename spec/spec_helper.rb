# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'

require_relative 'test_load_all'

def wipe_database
  PetsTinder::Pet.map(&:destroy)
  PetsTinder::Habit.map(&:destroy)
  PetsTinder::Account.map(&:destroy)
end

DATA = {
  accounts: YAML.load(File.read('app/db/seeds/accounts_seed.yml')),
  habits: YAML.load(File.read('app/db/seeds/habits_seed.yml')),
  pets: YAML.load(File.read('app/db/seeds/pets_seed.yml'))
}.freeze
