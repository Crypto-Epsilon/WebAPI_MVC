# frozen_string_literal: true

require 'http'

module PetsTinder
  # Create Verify Registration class
  class VerifyRegistration
    class InvalidRegistration < StandardError; end

    def initialize(registration)
      @registration = registration
    end

    # rubocop:disable Layout/EmptyLineBetweenDefs
    def from_email() = ENV['SENDGRID_FROM_EMAIL']
    def mail_api_key() = ENV['SENDGRID_API_KEY']
    def mail_url() = 'https://api.sendgrid.com/v3/mail/send'
    # rubocop:enable Layout/EmptyLineBetweenDefs

    def call
      raise(InvalidRegistration, 'Username exists') unless username_available?
      raise(InvalidRegistration, 'Email already used') unless email_available?

      send_email_verification
    end

    def username_available?
      Account.first(username: @registration[:username]).nil?
    end

    def email_available?
      Account.first(email: @registration[:email]).nil?
    end

    def html_email
      <<~END_EMAIL
        <H1>Pets Tinder App Registration Received</H1>
        <p>Please <a href=\"#{@registration[:verification_url]}\">click here</a>
        to validate your email.
        You will be asked to set a password to activate your account.</p>
      END_EMAIL
    end

    def mail_form
      {
        personalizations: [{
          to: [{ 'email' => @registration[:email] }]
        }],
        from: { 'email' => from_email },
        subject: 'Credent Registration Verification',
        content: [
          { type: 'text/html',
            value: html_email }
        ]
      }
    end

    def send_email_verification
      HTTP.auth("Bearer #{mail_api_key}")
          .post(mail_url, json: mail_json)
    rescue StandardError => e
      puts "EMAIL ERROR: #{e.inspect}"
      raise(InvalidRegistration,
            'Could not send verification email; please check email address')
    end
  end
end