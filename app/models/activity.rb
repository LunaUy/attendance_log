class Activity < ApplicationRecord
    has_many :attendances, dependent: :destroy
    has_many :recurring_schedules, dependent: :destroy

    validates :name, presence: true
    # Agregar validación de sintaxis del nombre.
end