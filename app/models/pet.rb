# frozen_string_literal: true

require 'json'
require 'sequel'

module PetsTinder
  class Pet < Sequel::Model
    many_to_one :owner, class: :'PetsTinder::Account'

    many_to_many :swipers,
                 class: :'PetsTinder::Account',
                 join_table: :accounts_pets,
                 left_key: :pet_id, right_key: :swiper_id

    one_to_many :habits

    plugin :association_dependencies,
           habits: :destroy,
           swipers: :nullify

    plugin :timestamps
    plugin :whitelist_security
    set_allowed_columns :name, :description

    def to_json(options = {})
      JSON(
        {
            type: 'pet',
            attributes: {
              id: id,
              petname: petname,
              petrace: petrace,
              birthday: birthday,
              description: description
            }
        }, options
      )
    end
  end
end
