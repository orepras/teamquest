class CreateCharacterSkills < ActiveRecord::Migration[8.0]
  def change
    create_table :character_skills do |t|
      t.references :character, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      t.index [ :character_id, :skill_id ], unique: true
      t.string :tier, null: false, default: "novice"
      t.integer :skill_xp, null: false, default: 0

      t.timestamps
    end
  end
end
