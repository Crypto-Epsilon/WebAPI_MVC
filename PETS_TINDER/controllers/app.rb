require 'roda'
require 'json'

require_relative '../models/pet'

module Pets_Tinder

    class Api < Roda
        plugin :environments
        plugin :halt

        configure do
            Pet.setup
        end

        route do |routing| 
            response['Content-Type'] = 'application/json'
      
            routing.root do
              response.status = 200
              { message: 'Pets_TenderAPI up at /api/v1' }.to_json
            end

            routing.on 'api' do
                routing.on 'v1' do
                  routing.on 'pet' do
                    # GET api/v1/pet/[id]
                    routing.get String do |id|
                      response.status = 200
                      Pet.find(id).to_json
                    rescue StandardError
                      routing.halt 404, { message: 'Pet not found' }.to_json
                    end
        
                    # GET api/v1/pet
                    routing.get do
                      response.status = 200
                      output = { pet_ids: Pet.all }
                      JSON.pretty_generate(output)
                    end
        
                    # POST api/v1/pet
                    routing.post do
                      new_data = JSON.parse(routing.body.read)
                      new_pet = Pet.new(new_data)
        
                      if new_pet.save
                        response.status = 201
                        { message: 'Pet registered', id: new_pet.id }.to_json
                      else
                        routing.halt 400, { message: 'Could not register your pet' }.to_json
                      end
                    end
                  end
                end
              end
            end
          end
        end
      

