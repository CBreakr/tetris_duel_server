class CreateGamestate < ActiveRecord::Migration[6.0]
  def change
    create_table :game_states do |t|
      t.integer :game_id
      t.string :board_state
      t.string :next_piece
      t.integer :move_number
      t.boolean :is_finished
      t.timestamps
    end
  end
end
