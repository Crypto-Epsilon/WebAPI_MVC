# frozen_string_literal: true

require_relative './spec_helper'

describe 'Test pet' do
  include Rack::Test::Methods

  before do
    wipe_database

    DATA[:habits].each do |habit_data|
        Pets_Tinder::Habit.create(habit_data)
    end
  end

  it 'HAPPY: should be able to get list of all pets' do
    pet1 = Pets_Tinder::Habit.first
    DATA[:pets].each do |hab|
      proj.add_document(hab)
    end

    get "api/v1/habits/#{proj.id}/pets"
    _(last_response.status).must_equal 200

    result = JSON.parse last_response.body
    _(result['data'].count).must_equal 2
  end

  it 'HAPPY: should be able to get details of a single pet' do
    pet_data = DATA[:pets][1]
    hab = Pets_Tinder::Habit.first
    pet1 = hab.add_pet(pet_data).save

    get "/api/v1/habits/#{hab.id}/pets/#{pet1.id}"
    _(last_response.status).must_equal 200

    result = JSON.parse last_response.body
    _(result['data']['attributes']['id']).must_equal pet1.id
    _(result['data']['attributes']['petname']).must_equal pet_data['petname']
  end

  it 'SAD: should return error if unknown  pet' do
    hab = Pets_Tinder::Habit.first
    get "/api/v1/habits/#{proj.id}/pets/foobar"

    _(last_response.status).must_equal 404
  end

  it 'HAPPY: should be able to create new pets' do
    hab = Pets_Tinder::Habit.first
    pet_data = DATA[:pets][1]

    req_header = { 'CONTENT_TYPE' => 'application/json' }
    post "api/v1/habits/#{hab.id}/pets",
    pet_data.to_json, req_header
    _(last_response.status).must_equal 201
    _(last_response.header['Location'].size).must_be :>, 0

    created = JSON.parse(last_response.body)['data']['data']['attributes']
    pet1 = Pets_Tinder::Pets.first

    _(created['id']).must_equal pet1.id
    _(created['petname']).must_equal pet_data['petname']
    _(created['petrace']).must_equal pet_data['petrace']
    _(created['birthday']).must_equal pet_data['birthday']
    _(created['description']).must_equal pet_data['description']
  end
end