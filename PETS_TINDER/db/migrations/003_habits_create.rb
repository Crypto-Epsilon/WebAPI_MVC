require 'sequel'

Sequel.migration do
  change do
    create_table(:habits) do
      primary_key :id

      String :name_secure, null: false
      String :category_secure, null: false
      String :description_secure, null: false, defaulf: ''
      #Changed Description name to 'descriptionha' to avoid collision with description in pets
      #it will never has collision because they are not in the same table

      DateTime :created_at
      DateTime :updated_at
    end
  end
end