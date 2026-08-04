class ActivitiesController < ApplicationController
  def index
    @activities = Activity.where(
      start_time: Time.current.beginning_of_day..Time.current.end_of_day
    )
  end
end