class Classroom < ApplicationRecord
  has_many :sections, dependent: :destroy

  validates :name, uniqueness: :true
end
