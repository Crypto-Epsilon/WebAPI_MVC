require 'sequel'

Sequel.migration do
  change do
    create_table(:habits) do
      primary_key :id

      String :name, null: false
      String :category, null: false
      String :description, null: false, defaulf: ''

      DateTime :created_at
      DateTime :updated_at
    end
  end
end