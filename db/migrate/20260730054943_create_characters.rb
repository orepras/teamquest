class CreateCharacters < ActiveRecord::Migration[8.0]
  def change
    create_table :characters do |t|
      t.references :user, index: { unique: true }, null: false, foreign_key: true
      t.string :name, null: false
      t.string :character_class, null: false
      t.string :subclass
      t.string :title
      t.string :avatar
      t.text :backstory
      t.integer :strength, null: false, default: 5
      t.integer :intellect, null: false, default: 5
      t.integer :wisdom, null: false, default: 5
      t.integer :dexterity, null: false, default: 5
      t.integer :charisma, null: false, default: 5
      t.integer :constitution, null: false, default: 5
      t.integer :xp_total, null: false, default: 0

      t.timestamps
    end
  end
end
