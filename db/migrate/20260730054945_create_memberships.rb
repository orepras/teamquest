class CreateMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :memberships do |t|
      t.references :character, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.string :role, null: false, default: "member"
      t.datetime :left_at
      t.index [ :character_id, :team_id ], unique: true

      t.timestamps
    end
  end
end
