# frozen_string_literal: true
class Section < ApplicationRecord
  VALID_WEEKDAYS =
    [
      'MWF',          # monday, wednesday, friday
      'TueThu',       # tuesday, thursday
      'every_day'     # monday through friday
    ].freeze
  VALID_DURATIONS =
    [
      50.minutes,
      80.minutes
    ].freeze

  belongs_to :teacher_subject
  belongs_to :classroom
  has_many :student_sections, dependent: :destroy
  has_many :students, through: :student_sections

  validates :weekdays, presence: true, inclusion: VALID_WEEKDAYS
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :duration_check
  validate :business_hours_check
  validate :overlap_check

  scope :other, ->(id) { where.not(id: id) }
  scope :same_day, (lambda do |weekdays|
    if weekdays != 'every_day'
      where(weekdays: [weekdays, 'every_day'])
    end
  end)

  def overlaps_other_sections?(scope)
    overlaps_other?(scope, start_at) || overlaps_other?(scope, end_at)
  end

  private

  def duration_check
    return true if VALID_DURATIONS.include? (end_at - start_at).round

    errors.add(:end_at, 'should be exactly 50 or 80 minutes after start')
  end

  def overlap_check
    errors.add(:start_at, 'overlaps other sections in classroom') if overlaps_other?(classroom.sections, start_at)
    errors.add(:end_at, 'overlaps other sections in classroom') if overlaps_other?(classroom.sections, end_at)
    if overlaps_other?(teacher_subject.teacher.sections, start_at)
      errors.add(:start_at, 'overlaps other sections of a teacher')
    end
    if overlaps_other?(teacher_subject.teacher.sections, end_at)
      errors.add(:end_at, 'overlaps other sections of a teacher')
    end
  end

  def business_hours_check
    errors.add(:start_at, 'not within business hours') unless start_at.during_business_hours?
    errors.add(:end_at, 'not within business hours') unless end_at.during_business_hours?
  end

  def overlaps_other?(scope, start_or_end_time)
    scope.other(id).same_day(weekdays).where('? between start_at and end_at', start_or_end_time).any?
  end
end
