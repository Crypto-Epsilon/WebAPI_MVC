# frozen_string_literal: true
require 'simplecov'
SimpleCov.start

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

def auth_header(account_data)
  auth = PetsTinder::AuthenticateAccount.call(
    username: account_data['username'],
    password: account_data['password']
  )

  "Bearer #{auth[:attributes][:auth_token]}"
end

def authorization(account_data)
  auth = authenticate(account_data)

  contents = AuthToken.contents(auth[:attributes][:auth_token])
  account = contents['payload']['attributes']
  { account: PetsTinder::Account.first(username: account['username']),
    scope: AuthScope.new(contents['scope']) }
end

DATA = {
  accounts: YAML.load(File.read('app/db/seeds/accounts_seed.yml')),
  habits: YAML.load(File.read('app/db/seeds/habits_seed.yml')),
  pets: YAML.load(File.read('app/db/seeds/pets_seed.yml'))
}.freeze

