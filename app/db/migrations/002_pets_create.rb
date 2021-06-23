# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:pets) do
      primary_key :id
      foreign_key :owner_id, :accounts

      String :petname, null: false
      String :petrace, null: false
      Date :birthday, null: false
      String :description, null: true, default: ''

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
