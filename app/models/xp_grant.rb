class XpGrant < ApplicationRecord
  # XP categories and default amounts (PRD §3.4)
  CATEGORIES = {
    "task_small"      => { label: "Task completed (small)",  default_xp: 10 },
    "task_medium"     => { label: "Task completed (medium)", default_xp: 25 },
    "task_large"      => { label: "Task completed (large)",  default_xp: 50 },
    "milestone"       => { label: "Milestone / release shipped", default_xp: 100 },
    "bug_fix"         => { label: "Bug slain", default_xp: 15 },
    "assist"          => { label: "Helped a teammate", default_xp: 10 },
    "knowledge_share" => { label: "Knowledge sharing", default_xp: 30 },
    "client_praise"   => { label: "Client praise", default_xp: 40 },
    "custom"          => { label: "Custom", default_xp: 25 }
  }.freeze

  MAX_AMOUNT = 100

  belongs_to :team
  belongs_to :granter, class_name: "Character"
  has_many :xp_grant_recipients, dependent: :destroy
  has_many :recipients, through: :xp_grant_recipients, source: :character

  validates :category, inclusion: { in: CATEGORIES.keys }
  validates :amount, numericality: { only_integer: true, in: 1..MAX_AMOUNT }
  validate :has_recipients
  validate :granter_not_a_recipient

  scope :effective, -> { where(voided_at: nil) }

  # Creates the grant and updates each recipient's xp_total atomically.
  # `amount` is XP per recipient.
  def self.record!(team:, granter:, category:, amount:, note:, recipients:)
    transaction do
      grant = create!(team:, granter:, category:, amount:, note:, recipients:)
      recipients.each { |c| c.increment!(:xp_total, amount) }
      grant
    end
  end

  def void!
    return if voided_at?
    transaction do
      touch(:voided_at)
      recipients.each { |c| c.decrement!(:xp_total, amount) }
    end
  end

  def category_label = CATEGORIES.fetch(category).fetch(:label)

  private

  def has_recipients
    errors.add(:base, "Pick at least one recipient") if recipients.empty?
  end

  def granter_not_a_recipient
    errors.add(:base, "You cannot grant XP to yourself") if recipients.include?(granter)
  end
end
