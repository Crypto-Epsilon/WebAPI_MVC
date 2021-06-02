# frozen_string_literal: true

require_relative './spec_helper'

describe 'Test habit' do
  before do
    wipe_database

    DATA[:pets].each do |pet_data|
      Pets_Tinder::Pet.create(pet_data)
    end 
  end

  it 'HAPPY: should retrieve correct data from database' do
    hab_data = DATA[:habits][1]
    pet = Pets_Tinder::Pet.first
    new_hab = pet.add_habit(hab_data)

    hab = Pets_Tinder::Habit.find(id: new_hab.id)
    
    
    _(hab.name).must_equal new_hab.name
    _(hab.category).must_equal new_hab.category
    _(hab.description).must_equal new_hab.description
  end

  it 'SECURITY: should not use deterministic integers' do
    hab_data =  DATA[:habits][1]
    pet = Pets_Tinder::Pet.first
    new_hab = pet.add_habit(hab_data)

    _(new_hab.id.is_a?(Numeric)).must_equal false
  end

  it 'SECURITY: should secure sensitive attributes' do
    hab_data =  DATA[:habits][1]
    pet = Pets_Tinder::Pet.first
    new_hab = pet.add_habit(hab_data)
    stored_hab = app.DB[:habits].first

    _(stored_hab[:name_secure]).wont_equal new_doc.name
    _(stored_hab[:description_secure]).wont_equal new_doc.description
  end

end
