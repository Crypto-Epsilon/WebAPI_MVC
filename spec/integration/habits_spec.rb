# frozen_string_literal: true

require_relative './spec_helper'

describe 'Test habit' do
  include Rack::Test::Methods

  before do
    wipe_database
  end

  it 'HAPPY: should be able to get list of all habits' do
    Pets_Tinder::Habit.create(DATA[:habitss][0]).save
    Pets_Tinder::Habit.create(DATA[:habits][1]).save

    get 'api/v1/habits'
    _(last_response.status).must_equal 200

    result = JSON.parse last_response.body
    _(result['data'].count).must_equal 2
  end

  it 'HAPPY: should be able to get details of a single habit' do
    existing_hab = DATA[:habits[1]]
    Pets_Tinder::Habit.create(existing_hab).save
    id = Pets_Tinder::Habit.first.id

    get "/api/v1/habits/#{id}"
    _(last_response.status).must_equal 200

    result = JSON.parse last_response.body
    _(result['data']['attributes']['id']).must_equal id
    _(result['data']['attributes']['name']).must_equal existing_hab['name']
  end

  it 'SAD: should return error if unknown habit requested' do
    get '/api/v1/habits/foobar'

    _(last_response.status).must_equal 404
  end

  it 'HAPPY: should be able to create new habits' do
    existing_hab = DATA[:habits][1]

    req_header = { 'CONTENT_TYPE' => 'application/json' }
    post 'api/v1/habits', existing_hab.to_json, req_header
    _(last_response.status).must_equal 201
    _(last_response.header['Location'].size).must_be :>, 0

    created = JSON.parse(last_response.body)['data']['data']['attributes']
    hab = Pets_Tinder::Habit.first

    _(created['id']).must_equal hab.id
    _(created['name']).must_equal existing_hab['name']
    _(created['category']).must_equal existing_hab['category']
    _(created['description']).must_equal existing_hab['description']
  end

  it 'SECURITY: should not create documents with mass assignment' do
    bad_data = @existing_hab.clone
    bad_data['created_at'] = '1900-01-01'
    post 'api/v1/habits',
         bad_data.to_json, @req_header

    _(last_response.status).must_equal 400
    _(last_response.header['Location']).must_be_nil
  end
end
