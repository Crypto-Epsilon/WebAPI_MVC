require 'json'
require 'sequel'

module Pets_Tinder
   
    class Pet < Sequel::Model
        many_to_one :habit

        plugin :timestamp

        

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