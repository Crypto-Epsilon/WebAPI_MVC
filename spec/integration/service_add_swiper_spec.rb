# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test AddSwiperToPet service' do
  before do
    wipe_database

    DATA[:accounts].each do |account_data|
      Pets_Tinder::Account.create(account_data)
    end

    pet_data = DATA[:pets].first

    @owner = Pets_Tinder::Account.all[0]
    @swiper = Pets_Tinder::Account.all[1]
    @pet = Pets_Tinder::CreatePetForOwner.call(
      owner_id: @owner.id, pet_data: pet_data
    )
  end

  it 'HAPPY: should be able to add a swiper to a pet' do
    Pets_Tinder::AddSwiperToPet.call(
      email: @swiper.email,
      pet_id: @pet.id
    )

    _(@swiper.pets.count).must_equal 1
    _(@swiper.pets.first).must_equal @pet
  end

  it 'BAD: should not add owner as a swiper' do
    _(proc {
        Pets_Tinder::AddSwiperToPet.call(
        email: @owner.email,
        pet_id: @pet.id
      )
    }).must_raise Pets_Tinder::AddSwiperToPet::OwnerNotSwiperError
  end
end