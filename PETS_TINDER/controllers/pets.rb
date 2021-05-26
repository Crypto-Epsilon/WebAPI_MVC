require 'roda'
require 'json'

require_relative '../models/pet'

module Pets_Tinder
    # Web controller for Pets_Tinder API
    class Api < Roda
      
    route('pets') do |routing|
        @pet_route = "#{@api_root}/pets"
        
        routing.on 'pets' do
            @pet_route = "#{@api_root}/pets"
  
            routing.on String do |id_pet|
              routing.on 'habits' do
                @hab_route = "#{@api_root}/pets/#{id_pet}/habits"
                # GET api/v1/pets/[id_pet]/habits/[hab_id]
                routing.get String do |hab_id|
                  hab = Habit.where(pet_id: id_pet, id: hab_id).first
                  hab ? hab.to_json : raise('Habit not found')
                rescue StandardError => e
                  routing.halt 404, { message: e.message }.to_json
                end
  
                # GET api/v1/pets/[id_pet]/habits
                routing.get do
                  output = { data: Pet.first(id: id_pet).habits }
                  JSON.pretty_generate(output)
                rescue StandardError
                  routing.halt 404, message: 'Could not find habits'
                end
  
                # POST api/v1/pets/[id_pet]/habits
                routing.post do
                  new_data = JSON.parse(routing.body.read)
                  pet = Pet.first(id: id_pet)
                  new_hab = pet.add_habit(new_data)
                  raise 'Could not save habit' unless new_hab
  
                  response.status = 201
                  response['Location'] = "#{@hab_route}/#{new_hab.id}"
                  { message: 'Habit saved', data: new_hab }.to_json
                rescue Sequel::MassAssignmentRestriction
                  Api.logger.warn "MASS-ASSIGNMENT: #{new_data.keys}"
                  routing.halt 400, { message: 'Illegal Attributes' }.to_json
                rescue StandardError => e
                  routing.halt 500, { message: e.message }.to_json
                end
              end
  
              # GET api/v1/pets/[pet_id]
              routing.get do
                pett = Pet.first(id: pet_id)
                pett ? pett.to_json : raise('Pet not found')
              rescue StandardError => e
                routing.halt 404, { message: e.message }.to_json
              end
            end
  
            # GET api/v1/pets
            routing.get do
              output = { data: Pet.all }
              JSON.pretty_generate(output)
            rescue StandardError
              routing.halt 404, { message: 'Could not find pets' }.to_json
            end
  
            # POST api/v1/pets
            routing.post do
              new_data = JSON.parse(routing.body.read)
              new_pet = Pet.new(new_data)
              raise('Could not save pet') unless new_pet.save
  
              response.status = 201
              response['Location'] = "#{@pet_route}/#{new_pet.id}"
              { message: 'Pet saved', data: new_pet }.to_json
            rescue Sequel::MassAssignmentRestriction
              Api.logger.warn "MASS-ASSIGNMENT: #{new_data.keys}"
              routing.halt 400, { message: 'Illegal Attributes' }.to_json
            rescue StandardError => e
              Api.logger.error "UNKOWN ERROR: #{e.message}"
              routing.halt 500, { message: "Unknown server error" }.to_json
            end
        end
    end
end