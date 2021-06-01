# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_join_table(owner_id: :accounts, pet_id: :pets)
  end
end
