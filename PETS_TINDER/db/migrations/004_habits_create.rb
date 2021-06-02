# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:habits) do
      uuid :id, primary_key: true
      foreign_key :pet_id, table: :pets

      String :name_secure, null: false
      String :category_secure, null: false
      String :description_secure, null: false, defaulf: ''
      # Changed Description name to 'descriptionha' to avoid collision with description in pets
      # it will never has collision because they are not in the same table

      DateTime :created_at
      DateTime :updated_at

      unique [:pet_id, :name_secure]
    end
  end
end
