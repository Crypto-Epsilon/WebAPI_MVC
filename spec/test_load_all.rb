# frozen_string_literal: true

require 'rack/test'
require_relative '/app/require_app'

require_app

def app = PetsTinder::Api

unless app.environment == :production
  require 'rack/test'
  include Rack::Test::Methods # rubocop:disable Style/MixinUsage
end
