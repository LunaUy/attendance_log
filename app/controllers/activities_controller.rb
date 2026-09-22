class ActivitiesController < ApplicationController
  def index
    @selected_date = if params[:date].present?
                       Date.iso8601(params[:date])
                     else
                       Date.current
                     end
    @activities = Activity.where(active: true).order(:name)
    @attendances = Attendance.includes(:activity).where(scheduled_at: @selected_date.all_day).order(:scheduled_at)
  end
end