require 'json'
require 'sequel'

module Pets_Tinder
   
    class Pet < Sequel::Model
        many_to_one :habits
        plugin :association_dependencies, habits: :destroy

        plugin :uuid, field: :id
        plugin :timestamp
        plugin :whitelist_security
        set_allowed_columns :petname, :petrace, :birthday, :description

        

        def to_json(options= {})
            JSON(
                {
                data: {
                    type: 'pet',
                    attributes: {
                        id: id,
                        petname: petname,
                        petrace: petrace,
                        birthday: birthday,
                        description: description
                    }
                },
                included: {
                    habit: habit
                }
                },options
            )
        end 

        
    end
end