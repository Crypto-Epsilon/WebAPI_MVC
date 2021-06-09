module PetsTender
    # Add a collaborator to another owner's existing project
    class GetHabitQuery
      # Error for owner cannot be collaborator
      class ForbiddenError < StandardError
        def message
          'You are not allowed to edit or delete that habit'
        end
      end
  
      # Error for cannot find a project
      class NotFoundError < StandardError
        def message
          'We could not find that habit'
        end
      end
  
      # Document for given requestor account
      def self.call(requestor:, habit:)
        raise NotFoundError unless habit
  
        policy = HabitPolicy.new(requestor, document)
        raise ForbiddenError unless policy.can_edit? || policy.can_delete?
  
        habit
      end
    end
end