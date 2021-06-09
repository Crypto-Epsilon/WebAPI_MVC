# frozen_string_literal: true

# Policy to determine if account can view an habit
class HabitPolicy
    def initialize(account, habit)
      @account = account
      @habit = habit
    end
  
    def can_view?
        account_view?
    end
  
    def can_edit?
        account_owns_pet?
    end
  
    def can_delete?
        account_owns_pet?
    end
  
    def summary
      {
        can_view: can_view?,
        can_edit: can_edit?,
        can_delete: can_delete?
      }
    end
  
    private
  
    def account_owns_pet?
      @habit.pet.owner == @account
    end

    def account_view?
        @account
    end
end