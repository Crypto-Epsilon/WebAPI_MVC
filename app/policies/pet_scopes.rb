# frozen_string_literal: true

module PetsTinder
    # Policy to determine if account can view a project
    class PetPolicy
      # Scope of pet policies
      class AccountScope
        def initialize(current_account, target_account = nil)
          target_account ||= current_account
          @full_scope = all_pets(target_account)
          @current_account = current_account
          @target_account = target_account
        end
  
        def viewable
          if @current_account || @target_account
            @full_scope
          end
        end
  
        private
  
        def all_pets(account)
          account.owned_pets + account.swipes
        end
      end
    end
end