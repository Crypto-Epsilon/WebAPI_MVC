# frozen_string_literal: true

module PetsTinder
    # Add a collaborator to another owner's existing project
    class GetPetQuery
      # Error for owner cannot be collaborator
      class ForbiddenError < StandardError
        def message
          'You are not allowed to edit that pet'
        end
      end
  
      # Error for cannot find a project
      class NotFoundError < StandardError
        def message
          'We could not find that project'
        end
      end
  
      def self.call(account:, pet:)
        raise NotFoundError unless pet
  
        policy = PetPolicy.new(account, pet)
        raise ForbiddenError unless policy.can_edit?
  
        project.full_details.merge(policies: policy.summary)
      end
    end
end