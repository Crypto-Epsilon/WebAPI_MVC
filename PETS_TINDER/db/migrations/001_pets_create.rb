require 'sequel'

Sequel.migration do 
    change do
        create_table(:pets) do
            uuid :id, primary_key: true
            foreign_key :habit_id, table: :habits

            String :petname, null: false
            String :petrace, null: false
            Date :birthday, null: false
            String :description, null: false, default: ''

            DateTime :created_at
            DateTime :updated_at

            unique [:habit_id]
        end
    end
end