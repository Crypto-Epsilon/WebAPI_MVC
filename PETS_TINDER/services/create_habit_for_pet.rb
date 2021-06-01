# frozen_string_literal: true

module Pets_Tinder
  # Create new habit for pet
  class CreateHabitForPet
    def self.call(pet_id:, habit_data:)
      Pet.first(id: pet_id)
         .add_habit(habit_data)
    end
  end
end
