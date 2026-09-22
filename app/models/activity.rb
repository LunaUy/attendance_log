class Activity < ApplicationRecord
    has_many :attendances
    has_many :recurring_schedules
end