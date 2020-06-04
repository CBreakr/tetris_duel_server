class CreateMatchState < ActiveRecord::Migration[6.0]
  def change
    create_table :match_states do |t|
      t.integer :match_id
      t.integer :game_state_id
      t.timestamps
    end
  end
end
