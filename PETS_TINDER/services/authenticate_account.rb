module Pets_Tinder
    # Error for invalid credentials
  class AuthenticateAccount

    class UnauthorizedError < StandardError
      def initialize(msg = nil)
        super
        @credentials = msg
      end
  
      def message
        "Invalid Credentials for: #{@credentials[:username]}"
      end
    end
    
    def self.call(credentials)
      account = Account.first(username: credentials[:usernam])
      raise unless account.password?(credentials[:password])

      account_and_token(account)
    rescue StandardError
      raise(UnauthorizedError, credentials)
    end

   
    def self.account_and_token(account)
      {
        type: 'authenticated_account',
        attributes: {
          account: account,
          auth_token: AuthToken.create(account)
        }
      }
    end  
  end
end