class CharacterSkill < ApplicationRecord
  # Proficiency tiers (PRD §3.3)
  TIERS = %w[novice apprentice adept expert master].freeze

  belongs_to :character
  belongs_to :skill

  validates :tier, inclusion: { in: TIERS }
  validates :skill_id, uniqueness: { scope: :character_id }
end
