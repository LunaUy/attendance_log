class RecurringSchedule < ApplicationRecord
  belongs_to :activity

  validates :weekday, inclusion: { in: 1..7, message: "must be between 1 (Monday) and 7 (Sunday)" }
  validates :weekday, uniqueness: { scope: [:activity_id, :starts_at, :effective_from], message: "should be unique for the same activity, start time, and effective from date" }

  validates :effective_from, presence: true
  validate :ends_after_starts
  validate :effective_until_after_effective_from

  private

  def ends_after_starts
    return if starts_at.blank? || ends_at.blank?

    errors.add(:ends_at, "must be after the start time") if ends_at <= starts_at
  end

  def effective_until_after_effective_from
    return if effective_from.blank? || effective_until.blank?

    errors.add(:effective_until, "must be on or after the start date") if effective_until < effective_from
  end
end