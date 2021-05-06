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

        #Secure getter and setters
        def petname
            SecureDB.decrypt(petname_secure)
        end

        def petname
            self.petname_secure = SecureDB.encrypt(plaintext)
        end

        def petrace
            SecureDB.decrypt(petrace_secure)
        end

        def petrace
            self.petrace_secure = SecureDB.encrypt(plaintext)
        end

        def birthday
            SecureDB.decrypt(birthday_secure)
        end

        def birthday
            self.birthday_secure = SecureDB.encrypt(plaintext)
        end

        def description
            SecureDB.decrypt(description_secure)
        end

        def description
            self.description_secure = SecureDB.encrypt(plaintext)
        end

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