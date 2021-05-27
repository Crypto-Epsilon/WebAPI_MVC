require 'json'
require 'sequel'

module Pets_Tinder
   
    class Pet < Sequel::Model
        many_to_one :owner, class: :'Pets_Tinder::Account'
       
        many_to_many :swipers,
                 class: :'Pets_Tinder::Account',
                 join_table: :accounts_pets,
                 left_key: :pet_id, right_key: :swiper_id
        
        one_to_many :habits

        plugin :association_dependencies,
           habits: :destroy,
           swipers: :nullify
        
        plugin :timestamps
        plugin :whitelist_security
        set_allowed_columns :name, :repo_url
       

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