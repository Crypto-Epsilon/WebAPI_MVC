# frozen_string_literal: true

Sequel.seed(:development) do
  def run
    puts 'Seeding accounts, pets, habits'
    create_accounts
    create_owned_pets
    create_habits
    add_swipers
  end
end

require 'yaml'
DIR = File.dirname(__FILE__)
ACCOUNTS_INFO = YAML.load_file("#{DIR}/accounts_seed.yml")
OWNER_INFO = YAML.load_file("#{DIR}/owners_pets.yml")
PET_INFO = YAML.load_file("#{DIR}/pets_seed.yml")
HABIT_INFO = YAML.load_file("#{DIR}/habits_seed.yml")
SWIPER_INFO = YAML.load_file("#{DIR}/pets_swipers.yml")

def create_accounts
  ACCOUNTS_INFO.each do |account_info|
    PetsTinder::Account.create(account_info)
  end
end

def create_owned_pets
  OWNER_INFO.each do |owner|
    account = PetsTinder::Account.first(username: owner['username'])
    owner['pet_name'].each do |pet_name|
      pet_data = PET_INFO.find { |pet| pet['name'] == pet_name }
      PetsTinder::CreatePetForOwner.call(
        owner_id: account.id, pet_data: pet_data
      )
    end
  end
end

def create_habits
  hab_info_each = HABIT_INFO.each
  pets_cycle = PetsTinder::Pet.all.cycle
  loop do
    hab_info = hab_info_each.next
    pet = pets_cycle.next
    PetsTinder::CreateHabitForPet.call(
      pet_id: pet.id, habit_data: hab_info
    )
  end
end

def add_swipers
  swiper_info = SWIPER_INFO
  swiper_info.each do |swiper|
    pet = PetsTinder::Pet.first(name: swiper['pet_name'])
    swiper['swiper_email'].each do |email|
      PetsTinder::AddSwiperToPet.call(
        email: email, pet_id: pet.id
      )
    end
  end
end
