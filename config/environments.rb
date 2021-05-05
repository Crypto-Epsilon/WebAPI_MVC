# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'sequel'
require './app/lib/secure_db'
require 'logger'

module Pets_Tinder
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

    # Logger setup
    LOGGER = Logger.new($stderr)
    def self.logger() = LOGGER

    #I'm a little confused here, not sure if we still need to utilize the self.reload model
    configure :development, :test do
      require 'pry'
        # Allows running reload! in pry to restart entire app
        def self.reload!
          exec 'pry -r ./specs/test_load_all'
        end
        logger.level = Logger::ERROR
      end
  
      configure :development, :test do
        ENV['DATABASE_URL'] = 'sqlite://' + config.DB_FILENAME
      end

      configure :production do
        #Not sure yet
      end
  
      # For all environments, should we keep it here?
      configure do
        DB = Sequel.connect(ENV.delete['DATABASE_URL'])

        # Make the database accessible to other classes
        def self.DB() = DB # rubocop:disable Naming/MethodName
        end

        SecureDB.setup(config.DB_KEY)

      end
  end
end