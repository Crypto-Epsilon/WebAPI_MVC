require 'sequel'

Sequel.migration do 
    change do
        create_table(:pets) do
            uuid :id, primary_key: true
            foreign_key :habit_id, table: :habits

            String :petname_secure, null: false
            String :petrace_secure, null: false
            Date :birthday_secure, null: false
            String :description_secure, null: false, default: ''

            DateTime :created_at
            DateTime :updated_at

            unique [:habit_id]
        end
    end
end