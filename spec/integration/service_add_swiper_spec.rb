# frozen_string_literal: true

require_relative './spec_helper'

describe 'Test AddSwiperToPet service' do
  before do
    wipe_database

    DATA[:accounts].each do |account_data|
      PetsTinder::Account.create(account_data)
    end

    pet_data = DATA[:pets].first

    @owner = PetsTinder::Account.all[0]
    @swiper = PetsTinder::Account.all[1]
    @pet = PetsTinder::CreatePetForOwner.call(
      owner_id: @owner.id, pet_data: pet_data
    )
  end

  it 'HAPPY: should be able to add a swiper to a pet' do
    PetsTinder::AddSwiperToPet.call(
      email: @swiper.email,
      pet_id: @pet.id
    )

    _(@swiper.pets.count).must_equal 1
    _(@swiper.pets.first).must_equal @pet
  end

  it 'BAD: should not add owner as a swiper' do
    _(proc {
        PetsTinder::AddSwiperToPet.call(
        email: @owner.email,
        pet_id: @pet.id
      )
    }).must_raise PetsTinder::AddSwiperToPet::OwnerNotSwiperError
  end
end