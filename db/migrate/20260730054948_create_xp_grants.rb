class CreateXpGrants < ActiveRecord::Migration[8.0]
  def change
    create_table :xp_grants do |t|
      t.references :team, null: false, foreign_key: true
      t.references :granter, null: false, foreign_key: { to_table: :characters }
      t.string :category, null: false
      t.integer :amount, null: false
      t.text :note
      t.datetime :voided_at

      t.timestamps
    end
  end
end
