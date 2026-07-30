class XpGrantRecipient < ApplicationRecord
  belongs_to :xp_grant
  belongs_to :character
end
