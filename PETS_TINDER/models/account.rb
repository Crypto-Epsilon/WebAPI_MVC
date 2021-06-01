# frozen_string_literal: true

require 'sequel'
require 'json'
require_relative './password'

module Pets_Tinder
  # Models a registered account
  class Account < Sequel::Model
    one_to_many :owned_pet, class: :'Pets_Tinder::Pet', key: :owner_id
    plugin :association_dependencies, owned_pet: :destroy

    many_to_many :swipes,
                 class: :'Pets_Tinder::Pet',
                 join_table: :accounts_pets,
                 left_key: :swiper_id, right_key: :pet_id

    plugin :whitelist_security
    set_allowed_columns :username, :email, :password

    plugin :timestamps, update_on_create: true

    def pets
      owned_pet + swipes
    end

    def password=(new_password)
      self.password_digest = Password.digest(new_password)
    end

    def password?(try_password)
      digest = Pets_Tinder::Password.from_digest(password_digest)
      digest.correct?(try_password)
    end

    def to_json(options = {})
      JSON(
        {
          type: 'account',
          id: id,
          username: username,
          email: email
        }, options
      )
    end
  end
end
