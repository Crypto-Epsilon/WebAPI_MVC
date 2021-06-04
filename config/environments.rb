# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'sequel'
require 'logger'
require_app('lib')

module PetsTinder
  # Configuration for the API
  class Api < Roda
    plugin :environments

    Figaro.application = Figaro::Application.new(
      environment: environment,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config = Figaro.env

    # Logger setup
    def self.logger = Logger.new($stderr)

    DB = Sequel.connect("#{ENV.delete('DATABASE_URL')}?encoding=utf8")
    def self.DB = DB # rubocop:disable Naming/MethodName

    configure :development, :test do
      require 'pry'
      logger.level = Logger::ERROR
    end

    # configure do
    #   SecureDB.setup(ENV.delete('DB_KEY')) # Load crypto keys
    #   AuthToken.setup(ENV.delete('MSG_KEY')) # Load crypto keys
    # end
  end
end
