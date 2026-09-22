class Attendance < ApplicationRecord
  ATTENDANCE_STATUSES = %w[early on-time late missed].freeze
  SCHEDULE_STATES = %w[planned rescheduled cancelled].freeze

  belongs_to :activity
  belongs_to :recurring_schedule, optional: true

  validates :scheduled_at, presence: true
  validates :schedule_state, inclusion: { in: SCHEDULE_STATES }
  validates :status, inclusion: { in: ATTENDANCE_STATUSES }, allow_nil: true

  validate :cancelled_sessions_have_no_attendance_status
  validate :rescheduled_sessions_have_original_time

  private

  def cancelled_sessions_have_no_attendance_status
    return unless schedule_state == 'cancelled' && status.present?
    
    errors.add(:status, 'cannot be set for cancelled sessions')
  end

  def rescheduled_sessions_have_original_time
    return unless schedule_state == 'rescheduled'
    
    errors.add(:original_scheduled_at, 'must be set for rescheduled sessions') if original_scheduled_at.blank?

    if 
  end
end