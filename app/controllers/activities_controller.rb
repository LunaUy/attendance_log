class ActivitiesController < ApplicationController
  def index
    @activities = Activity.where(
      start_time: Time.current.beginning_of_month..Time.current.end_of_month
    )
  end
end

# CHANGE THE start_time: TO THE CORRECT CONDITION