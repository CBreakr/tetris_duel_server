class CreateMatch < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.integer :winner_id
      t.integer :loser_id
      t.integer :game1_id
      t.integer :game2_id
      t.timestamps
    end
  end
end
