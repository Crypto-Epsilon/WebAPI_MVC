# frozen_string_literal: true

module PetsTinder
    # Policy to determine if an account can view a particular pet
    class PetPolicy
      def initialize(account, pet)
        @account = account
        @pet = pet
      end
  
      def can_view?
        account_view
      end
  
      # duplication is ok!
      def can_edit?
        account_is_owner? 
      end
  
      def can_delete?
        account_is_owner?
      end
  
      def can_swipe?
        account_is_swiper?
      end
  
      def can_add_habits?
        account_is_owner? 
      end
  
      def can_remove_habits?
        account_is_owner? 
      end
  
      
      def summary
        {
          can_view: can_view?,
          can_edit: can_edit?,
          can_delete: can_delete?,
          can_swipe: can_swipe?,
          can_add_habits: can_add_habits?,
          can_remove_habits: can_remove_habits?,
         
        }
      end
  
      private
  
      def account_is_owner?
        @project.owner == @account
      end

      def account_view?
        @account
      end
  
      def account_is_swiper?
        @pet.swipers.include?(@account)
      end
    end
end