class AttendancesController < ApplicationController
    def index
        @include_archived = params[:include_archived] == "1"
        
        @activities = Activity.order(:name)
        @attendances = Attendance.includes(:activity).order(scheduled_at: :desc)
        
        unless @include_archived
            @activities = @activities.where(active: true)
            
            @attendances = @attendances.joins(:activity).where(activities: { active: true})
        end
        
        if params[:activity_id].present?
            @selected_activity_id = params[:activity_id]
            @attendances = @attendances.where(activity_id: @selected_activity_id)
        end
        
        if params[:date].present?
            @selected_date = Date.iso8601(params[:date])
            @attendances = @attendances.where(scheduled_at: @selected_date.all_day)
        end
    end
    
    def new
        @attendance = Attendance.new(scheduled_at: Time.current.beginning_of_minute)
        @activities = Activity.where(active: true).order(:name)
    end
    
    def create
        @attendance = Attendance.new(attendance_params)
        
        if @attendance.save
            redirect_to attendances_path, notice: "Attendance registered successfully."
        else
            @activities = Activity.where(active: true).order(:name)
            render :new, status: :unprocessable_entity
        end
    end
    
    def destroy
        attendance = Attendance.find(params[:id])
        attendance_name_before_deletion = attendance.activity.name
        attendance.destroy!
        redirect_back fallback_location: attendances_path, notice: "#{attendance_name_before_deletion} was deleted."
    end
    
    private
    
    def attendance_params
        params.require(:attendance).permit(:activity_id, :scheduled_at, :status)
    end
end