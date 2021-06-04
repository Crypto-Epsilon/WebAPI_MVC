# frozen_string_literal: true

require_relative '/app/require_app'
require_relative '/config/environment'
# require_app

def app
  PetsTinder::Api
end

unless app.environment == :production
  require 'rack/test'
  include Rack::Test::Methods # rubocop:disable Style/MixinUsage
end
