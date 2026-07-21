class ActivitiesController < ApplicationController
  def index
    @activities = Activity.where(
      date: Date.today.beginning_of_month..Date.today.end_of_month
    )
  end
end