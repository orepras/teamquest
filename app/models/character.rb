class Character < ApplicationRecord
  # Class registry: internal key => display data. "corporate" is the plain-mode
  # label for the flavor toggle (PRD §7.4).
  CLASSES = {
    "artificer"   => { emoji: "🛠️", fantasy: "Artificer",   corporate: "Developer",        flavor: "Builds the machinery that makes everything run" },
    "illusionist" => { emoji: "🎨", fantasy: "Illusionist", corporate: "Designer",         flavor: "Shapes what users see and feel" },
    "bard"        => { emoji: "📜", fantasy: "Bard",        corporate: "Project Manager",  flavor: "Keeps the party aligned, negotiates with clients" },
    "sentinel"    => { emoji: "🛡️", fantasy: "Sentinel",    corporate: "QA",               flavor: "Guards the gates against bugs" },
    "mechanist"   => { emoji: "⚙️", fantasy: "Mechanist",   corporate: "Ops/DevOps",       flavor: "Keeps the realm's infrastructure alive" },
    "oracle"      => { emoji: "🔮", fantasy: "Oracle",      corporate: "Data/Analyst",     flavor: "Reads the signs and predicts the future" },
    "herald"      => { emoji: "🗣️", fantasy: "Herald",      corporate: "Marketing/BizDev", flavor: "Spreads word of the guild's deeds" }
  }.freeze

  ATTRIBUTES = {
    strength:     { abbr: "STR", label: "Execution" },
    intellect:    { abbr: "INT", label: "Technical depth" },
    wisdom:       { abbr: "WIS", label: "Judgment" },
    dexterity:    { abbr: "DEX", label: "Adaptability" },
    charisma:     { abbr: "CHA", label: "Communication" },
    constitution: { abbr: "CON", label: "Consistency" }
  }.freeze

  # Point-buy budget at creation (PRD §4.2): 30 points, per-stat cap of 8.
  POINT_BUY_TOTAL = 30
  CREATION_STAT_CAP = 8

  AVATARS = %w[🧙 🧝 🧛 🦹 🦸 🧚 🧞 🐉 🦊 🦉 🐺 🏹].freeze

  belongs_to :user
  has_many :memberships, dependent: :destroy
  has_many :teams, -> { where(memberships: { left_at: nil }) }, through: :memberships
  has_many :character_skills, dependent: :destroy
  has_many :skills, through: :character_skills
  has_many :xp_grant_recipients, dependent: :destroy
  has_many :received_grants, -> { where(voided_at: nil) }, through: :xp_grant_recipients, source: :xp_grant

  validates :name, presence: true
  validates :character_class, inclusion: { in: CLASSES.keys }
  validates :subclass, inclusion: { in: CLASSES.keys }, allow_blank: true
  validates :avatar, inclusion: { in: AVATARS }
  ATTRIBUTES.each_key do |attr|
    validates attr, numericality: { only_integer: true, in: 1..10 }
  end
  validate :point_buy_within_budget, on: :create

  def class_info    = CLASSES.fetch(character_class)
  def subclass_info = subclass.presence && CLASSES.fetch(subclass)

  # Level curve (PRD §3.4): XP needed to *reach* level n = 100 * n * (n-1) / 2
  # => L2 at 100 XP, L3 at 300, L4 at 600, L5 at 1000 ...
  def level
    ((1 + Math.sqrt(1 + 8.0 * xp_total / 100)) / 2).floor
  end

  def self.xp_for_level(n) = 100 * n * (n - 1) / 2

  def xp_into_level     = xp_total - self.class.xp_for_level(level)
  def xp_for_next_level = self.class.xp_for_level(level + 1) - self.class.xp_for_level(level)
  def level_progress    = xp_into_level.to_f / xp_for_next_level

  def xp_in_team(team) = received_grants.where(team: team).sum(:amount)

  private

  def point_buy_within_budget
    total = ATTRIBUTES.keys.sum { |a| self[a].to_i }
    if total > POINT_BUY_TOTAL
      errors.add(:base, "Attribute points exceed the budget of #{POINT_BUY_TOTAL} (you spent #{total})")
    end
    ATTRIBUTES.each_key do |a|
      errors.add(a, "can be at most #{CREATION_STAT_CAP} at creation") if self[a].to_i > CREATION_STAT_CAP
    end
  end
end
