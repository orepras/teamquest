class Membership < ApplicationRecord
  ROLES = %w[admin member].freeze

  belongs_to :character
  belongs_to :team

  validates :role, inclusion: { in: ROLES }
  validates :character_id, uniqueness: { scope: :team_id }

  scope :active, -> { where(left_at: nil) }
end
