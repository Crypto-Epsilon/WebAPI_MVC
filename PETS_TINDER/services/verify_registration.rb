
require 'http'

module Pets_Tinder

    class VerifyRegistration
        class InvalidRegistration < StandardError; end

        def initialize(registration)
            @registration = registration
        end

        def mail_key() = ENV['f8c6bd963de7d748ea6288ebe6442522-1d8af1f4-cc159c24']
        def mail_domain() = ENV['sandbox8bd3db370f4a4f6f913f71674650ac80.mailgun.org']
        def mail_credentials() = "api:#{mail_key}"
        def mail_auth() = Base64.strict_encode64(mail_credentials)
        def main_url
            "https://#{mail_credentials}@api.mailgun.net/v3/#{mail_domain}/messages"
        end


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

        def text_email
            <<~END_EMAIL
              Pets Tinder Registration Received\n\n
              Please use the following url to validate your email:\n
              #{@registration[:verification_url]}\n\n
              You will be asked to set a password to activate your account.
            END_EMAIL
        end

        def mail_form
            {
              from: 'noreply@pets_tinder-app.com',
              to: @registration[:email],
              subject: 'Pets Tinder Registration Verification',
              text: text_email,
              html: html_email
            }
        end

        def send_email_verification
            HTTP
              .auth("Basic #{mail_auth}")
              .post(mail_url, form: mail_form)
          rescue StandardError => e
            puts "EMAIL ERROR: #{e.inspect}"
            raise(InvalidRegistration,
                  'Could not send verification email; please check email address')
          end
    end
end