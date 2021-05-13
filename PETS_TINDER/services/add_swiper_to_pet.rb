
module Pets_Tinder
    # Add a swiper
    class AddSwiperToPet
      def self.call(email:, project_id:)
        swiper = Account.first(email: email)
        pet = Project.first(id: pet_id)
        return false if pet.owner.id == swiper.id
  
        pet.add_swiper
        swiper
      end
    end
  end