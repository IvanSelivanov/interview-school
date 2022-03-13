class StudentSection < ApplicationRecord
  belongs_to :student
  belongs_to :section
  validates :student, uniqueness: { scope: :section }
  validate :can_enroll?

  private
  def can_enroll?
    errors.add(:student, 'can not enroll') unless student.can_enroll_section?(section)
  end
end
