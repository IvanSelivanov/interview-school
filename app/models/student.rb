class Student < ApplicationRecord
  has_many :student_sections
  has_many :sections, through: :student_sections

  def can_enroll_section?(section)
    !section.overlaps_other_sections?(sections)
  end
end
