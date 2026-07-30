class CreateXpGrantRecipients < ActiveRecord::Migration[8.0]
  def change
    create_table :xp_grant_recipients do |t|
      t.references :xp_grant, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true

      t.timestamps
    end
  end
end
