# frozen_string_literal: true

module Pets_Tinder
  # Add a swiper
  class AddSwiperToPet
    class OwnerNotSwiperError < StandardError
      def message = 'Owner cannot be Swiper of pet'
    end

    def self.call(email:, pet_id:)
      swiper = Account.first(email: email)
      pet = Pet.first(id: pet_id)

      raise(OwnerNotSwiperError) if pet.owner.id == swiper.id

      pet.add_swiper(swiper)
      swiper
    end
  end
end
