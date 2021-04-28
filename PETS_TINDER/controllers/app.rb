require 'roda'
require 'json'

require_relative '../models/pets'

module Pets_Tinder

    class Api < Roda
        plugin :environments
        plugin :halt

        configure do
            Pets.setup
        end

        route do |routing| 
            response['Content-Type'] = 'application/json'
      
            routing.root do
              response.status = 200
              { message: 'Pets_TenderAPI up at /api/v1' }.to_json
            end

            routing.on 'api' do
                routing.on 'v1' do
                  routing.on 'pets' do
                    # GET api/v1/pets/[id]
                    routing.get String do |id|
                      response.status = 200
                      Pets.find(id).to_json
                    rescue StandardError
                      routing.halt 404, { message: 'Pets not found' }.to_json
                    end
        
                    # GET api/v1/pets
                    routing.get do
                      response.status = 200
                      output = { pet_ids: Pets.all }
                      JSON.pretty_generate(output)
                    end
        
                    # POST api/v1/pets
                    routing.post do
                      new_data = JSON.parse(routing.body.read)
                      new_pets = Pets.new(new_data)
        
                      if new_pets.save
                        response.status = 201
                        { message: 'Pets registered', id: new_pets.id }.to_json
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
      

