
module Pets_Tinder
  # Service create PEt for owner
  class CreatePetForOwner
    def self.call(owner_id:, pet_data:)
      Account.find(id: owner_id)
             .add_owned_pet(pet_data)
    end
  end
end