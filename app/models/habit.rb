# frozen_string_literal: true

require 'json'
require 'sequel'

module PetsTinder
  class Habit < Sequel::Model
    many_to_one :pet

    plugin :uuid, field: :id
    plugin :timestamps, update_on_create: true

    plugin :whitelist_security
    set_allowed_columns :name, :category, :description

    def name
      SecureDB.decrypt(name_secure)
    end

    def name=(plaintext)
      self.name_secure = SecureDB.encrypt(plaintext)
    end

    def category
      SecureDB.decrypt(category_secure)
    end

    def category=(plaintext)
      self.category_secure = SecureDB.encrypt(plaintext)
    end

    def description
      SecureDB.decrypt(description_secure)
    end

    def description=(plaintext)
      self.description_secure = SecureDB.encrypt(plaintext)
    end

    def to_json(options = {})
      JSON(
        {
          data: {
            type: 'habit',
            attributes: {
              id: id,
              name: name,
              category: category,
              description: description
            }
          },
          included: {
            pet: pet
          }
        }, options
      )
    end
  end
end
