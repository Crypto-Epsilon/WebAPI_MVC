require 'json'
require 'sequel'

module Pets_Tinder
   
    class Habit < Sequel::Model
        one_to_many :pet

        plugin :association_dependencies, documents: :destroy

        plugin :timestamp

        

        def to_json(options= {})
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
                    habit: habit
                }
                },options
            )
        end 

        
    end
end