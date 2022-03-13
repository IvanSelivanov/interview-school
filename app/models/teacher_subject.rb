class TeacherSubject < ApplicationRecord
  DEFAULT_LEVEL = 5

  belongs_to :teacher
  belongs_to :subject # subjects are not deleted with the teacher. maybe we should use dependent: :destroy?
  has_many :sections

  validates :teacher, uniqueness: { scope: :subject }, if: :_not_marked_for_destruction?

  validates :level, presence: true
  before_validation :_default_values_on_create, on: :create

  def _default_values_on_create
    self.level ||= DEFAULT_LEVEL
    # return value should be true or nil
    true
  end

  def _not_marked_for_destruction?
    # Rails validation does not work well when we update subject with
    # teacher_subjects_attributes when we mark_for_destruction
    subject.teacher_subjects.none?(&:_destroy)
  end
end
