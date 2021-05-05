require 'json'
require 'sequel'

module Pets_Tinder
   
    class Habit < Sequel::Model
        one_to_many :pet

        plugin :association_dependencies, documents: :destroy

        plugin :timestamp

        def name
            SecureDB.decrypt(name_secure)
        end

        def name
            self.name_secure = SecureDB.encrypt(plaintext)
        end

        def category
            SecureDB.decrypt(category_secure)
        end

        def category
            self.category_secure = SecureDB.encrypt(plaintext)
        end

        def descriptionha
            SecureDB.decrypt(descriptionha_secure)
        end

        def descriptionha
            self.descriptionha_secure = SecureDB.encrypt(plaintext)
        end

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