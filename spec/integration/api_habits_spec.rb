# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Habit Handling' do
  include Rack::Test::Methods

  before do
    wipe_database

    DATA[:pets].each do |pet_data|
      PetsTinder::Pet.create(pet_data)
    end
  end

  it 'HAPPY: should be able to get list of all habits' do
    pet = PetsTinder::Pet.first
    DATA[:habits].each do |hab|
      pet.add_habit(hab)
    end

    get "api/v1/pes/#{pet.id}/habits"
    _(last_response.status).must_equal 200

    result = JSON.parse(last_response.body)['data']
    _(result.count).must_equal 4
    result.each do |hab|
      _(hab['type']).must_equal 'habit'
    end
  end

  it 'HAPPY: should be able to get details of a single habit' do
    hab_data = DATA[:habits][1]
    pet = PetsTinder::Pet.first
    hab = pet.add_habit(hab_data)

    get "/api/v1/pets/#{pet.id}/habits/#{hab.id}"
    _(last_response.status).must_equal 200

    result = JSON.parse last_response.body
    _(result['attributes']['id']).must_equal hab.id
    _(result['attributes']['name']).must_equal hab_data['name']
  end

  it 'SAD: should return error if unknown habit requested' do
    pet = PetsTinder::Pet.first
    get "/api/v1/pets/#{pet.id}/habits/foobar"

    _(last_response.status).must_equal 404
  end

  describe 'Creating habits' do
    before do
      @pet = PetsTinder::Pet.first
      @hab_data = DATA[:habits][1]
      @req_header = { 'CONTENT_TYPE' => 'application/json' }
    end

    it 'HAPPY: should be able to create new habits' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post "api/v1/pets/#{@pet.id}/habits",
           @hab_data.to_json, req_header
      _(last_response.status).must_equal 201
      _(last_response.header['Location'].size).must_be :>, 0

      created = JSON.parse(last_response.body)['data']['attributes']
      hab = PetsTinder::Habit.first

      _(created['id']).must_equal hab.id
      _(created['name']).must_equal @hab_data['name']
      _(created['description']).must_equal @hab_data['description']
    end

    it 'SECURITY: should not create habits with mass assignment' do
      bad_data = @hab_data.clone
      bad_data['created_at'] = '1900-01-01'
      post "api/v1/pets/#{@pet.id}/habits",
           bad_data.to_json, @req_header

      _(last_response.status).must_equal 400
      _(last_response.header['Location']).must_be_nil
    end
  end
end