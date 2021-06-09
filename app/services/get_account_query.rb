# frozen_string_literal: true

module PetsTinder
    # Add a collaborator to another owner's existing pet
    class GetAccountQuery
      # Error if requesting to see forbidden account
      class ForbiddenError < StandardError
        def message
          'You are not allowed to delete or this pet'
        end
      end
  
      def self.call(requestor:, username:)
        account = Account.first(username: username)
  
        policy = AccountPolicy.new(requestor, account)
        policy.can_edit? ? account : raise(ForbiddenError)
        policy.can_delete ? ccount : raise(ForbiddenError)
      end
    end
end