class AddInviteTokenToTeams < ActiveRecord::Migration[8.0]
  def change
    add_column :teams, :invite_token, :string
    add_index :teams, :invite_token, unique: true

    reversible do |dir|
      dir.up do
        Team.reset_column_information
        Team.where(invite_token: nil).find_each do |team|
          team.update_columns(invite_token: SecureRandom.base58(24))
        end
      end
    end
  end
end
