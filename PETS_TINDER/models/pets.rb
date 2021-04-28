require 'json'
require 'base64'
require 'rbnacl'
require 'sequel'

module Pets_Tinder
    STORE_DIR = 'PETS_TINDER/db/store'
    class Pets < Sequel::Model
        
        # EXAMPLES for our model below
        # one_to_many :documents
        # plugin :association_dependencies, documents: :destroy
        # plugin :timestamps

        #create a new pet by passing in hash of attributes
        def initialize(new_pet)
            @id = new_pet['id'] || new_id
            @petname = new_pet['petname']
            @petrace = new_pet['petrace']
            @birthday = new_pet['birthday']
            @description = new_pet['description']
        end

        attr_reader  :id, :petname, :petrace, :birthday, :description

        def to_json(options= {})
            JSON(
                {
                    type: 'pets',
                    id: id,
                    petname: petname,
                    petrace: petrace,
                    birthday: birthday,
                    description: description
                },
                options
            )
        end 

        def self.setup
            Dir.mkdir(Pets_Tinder::STORE_DIR) unless Dir.exist? Pets_Tinder::STORE_DIR
        end
        # Store new pet 
        def save
            File.write("#{Pets_Tinder::STORE_DIR}/#{id}.txt", to_json)
        end
        # To find a pet
        def self.find(find_id)
            pet_file = File.read("#{Pets_Tinder::STORE_DIR}/#{find_id}.txt")
            Document.new JSON.parse(pet_file)
        end
        def self.all
            Dir.glob("#{Pets_Tinder::STORE_DIR}/*.txt").map do |file|
                file.match(%r{#{Regexp.quote(Pets_Tinder::STORE_DIR)}\/(.*)\.txt})[1]
            end
        end

        private

        def new_id
            timestamp = Time.now.to_f.to_s
            Base64.urlsafe_encode64(RbNaCl::Hash.sha256(timestamp))[0..9]
        end
    end
end