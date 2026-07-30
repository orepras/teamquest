class Skill < ApplicationRecord
  CATEGORIES = %w[engineering design product operations communication].freeze

  has_many :character_skills, dependent: :destroy
  has_many :characters, through: :character_skills

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :category, inclusion: { in: CATEGORIES }
end
