class ActivitiesController < ApplicationController
  def index
    @activities = Activity.order(:name)
  end

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)

    if @activity.save
      redirect_to activities_path, notice: "Activity created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def archive
    activity = Activity.find(params[:id])
    activity.update!(active: false)

    redirect_to activities_path, notice: "#{activity.name} was archived."
  end

  def destroy
    activity = Activity.find(params[:id])
    activity_name_before_deletion = activity.name
    activity.destroy!

    redirect_to activities_path, notice: "#{activity_name_before_deletion} has been deleted."
  end

  private

  def activity_params
    params.require(:activity).permit(:name, :description)
  end
end