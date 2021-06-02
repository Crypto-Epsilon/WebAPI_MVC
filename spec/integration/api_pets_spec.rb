# frozen_string_literal: true

require_relative './spec_helper'

describe 'Test pet' do
  include Rack::Test::Methods

  before do
    wipe_database
  end

  describe 'Getting pets' do
    describe 'Getting list of pets' do
      before do
        @account_data = DATA[:accounts][0]
        account = Pets_Tinder::Account.create(@account_data)
        account.add_owned_pet(DATA[:pets][0])
        account.add_owned_pet(DATA[:pets][1])
      end

      it 'HAPPY: should get list for authorized account' do
        auth = Pets_Tinder::AuthenticateAccount.call(
          username: @account_data['username'],
          password: @account_data['password']
        )

        header 'AUTHORIZATION', "Bearer #{auth[:attributes][:auth_token]}"
        get 'api/v1/pets'
        _(last_response.status).must_equal 200

        result = JSON.parse last_response.body
        _(result['data'].count).must_equal 2
      end

      it 'BAD: should not process for unauthorized account' do
        header 'AUTHORIZATION', 'Bearer bad_token'
        get 'api/v1/pets'
        _(last_response.status).must_equal 403

        result = JSON.parse last_response.body
        _(result['data']).must_be_nil
      end
    end

    it 'HAPPY: should be able to get details of a single pet' do
      existing_pet = DATA[:pets][1]
      Pets_Tinder::Pet.create(existing_pet)
      id = Pets_Tinder::Pet.first.id

      get "/api/v1/pets/#{id}"
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result['attributes']['id']).must_equal id
      _(result['attributes']['petname']).must_equal existing_pet['petname']
    end

    it 'SAD: should return error if unknown pet requested' do
      get '/api/v1/pets/foobar'

      _(last_response.status).must_equal 404
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do
      Pets_Tinder::Pet.create(name: 'New Pet')
      Pets_Tinder::Pet.create(name: 'Newer Pet')
      get 'api/v1/pets/2%20or%20id%3E0'

      # deliberately not reporting error -- don't give attacker information
      _(last_response.status).must_equal 404
      _(last_response.body['data']).must_be_nil
    end
  end

  describe 'Creating New Pets' do
    before do
      @req_header = { 'CONTENT_TYPE' => 'application/json' }
      @pet_data = DATA[:pets][1]
    end

    it 'HAPPY: should be able to create new pets' do
      post 'api/v1/pets', @pet_data.to_json, @req_header
      _(last_response.status).must_equal 201
      _(last_response.header['Location'].size).must_be :>, 0

      created = JSON.parse(last_response.body)['data']['attributes']
      pet = Pets_Tinder::Pet.first

      _(created['id']).must_equal pet.id
      _(created['petname']).must_equal @pet_data['petname']
      _(created['petrace']).must_equal @pet_data['petrace']
      _(created['birthday']).must_equal @pet_data['birthday']
      _(created['description']).must_equal @pet_data['description']
    end

    it 'SECURITY: should not create pet with mass assignment' do
      bad_data = @pet_data.clone
      bad_data['created_at'] = '1900-01-01'
      post 'api/v1/pets', bad_data.to_json, @req_header

      _(last_response.status).must_equal 400
      _(last_response.header['Location']).must_be_nil
    end
  end
end