# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'sequel'

module PetsTinder
  # Configuration for the API
  class Api < Roda
    plugin :environments

    Figaro.application = Figaro::Application.new(
      environment: environment,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load

    # Make the environment variables accessible to other classes
    def self.config
      Figaro.env
    end

    configure :development, :test do
        # Allows running reload! in pry to restart entire app
        def self.reload!
          exec 'pry -r ./specs/test_load_all'
        end
      end
  
      configure :development, :test do
        ENV['DATABASE_URL'] = 'sqlite://' + config.DB_FILENAME
      end

      configure :production do
        #Not sure yet
      end
  
      # For all environments, should we keep it here?
      configure do
        require 'sequel'
        DB = Sequel.connect(ENV['DATABASE_URL'])

        # Make the database accessible to other classes
        def self.DB # rubocop:disable Naming/MethodName
            DB
        end
    end
end