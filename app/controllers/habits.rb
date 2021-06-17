# frozen_string_literal: true

require_relative './app'

module PetsTinder
  # Web controller for Credence API
  class Api < Roda
    route('habits') do |routing|
      unless @auth_account
        routing.halt 403, { message: 'Not authorized' }.to_json
      end

      @hab_route = "#{@api_root}/habits"

      # GET api/v1/habits/[hab_id]
      routing.on String do |hab_id|
        @req_habit = Habit.first(id: hab_id)

        routing.get do
          habit = GetHabitQuery.call(
            auth: @auth, habit: @req_habit
          )

          { data: habit }.to_json
        rescue GetHabitQuery::ForbiddenError => e
          routing.halt 403, { message: e.message }.to_json
        rescue GetHabitQuery::NotFoundError => e
          routing.halt 404, { message: e.message }.to_json
        rescue StandardError => e
          puts "GET HABIT ERROR: #{e.inspect}"
          routing.halt 500, { message: 'API server error' }.to_json
        end
      end
    end
  end
end