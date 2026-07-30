class Team < ApplicationRecord
  CRESTS = %w[🏰 ⚔️ 🐦‍🔥 🌋 🌊 🌲 ☀️ 🌙 ⭐ 🔥].freeze

  has_secure_token :invite_token, length: 24

  has_many :memberships, dependent: :destroy
  has_many :active_memberships, -> { where(left_at: nil) }, class_name: "Membership"
  has_many :characters, through: :active_memberships
  has_many :xp_grants, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :crest, inclusion: { in: CRESTS }, allow_blank: true

  scope :active, -> { where(archived_at: nil) }

  def admin?(character)
    active_memberships.exists?(character: character, role: "admin")
  end

  def member?(character)
    active_memberships.exists?(character: character)
  end

  def total_xp = xp_grants.where(voided_at: nil).sum(:amount)

  # Adds (or re-activates) a member. Used by both the Join button and invite links.
  def add_member!(character, role: "member")
    membership = memberships.find_or_initialize_by(character: character)
    membership.role = role if membership.new_record?
    membership.left_at = nil
    membership.save!
    membership
  end
end
