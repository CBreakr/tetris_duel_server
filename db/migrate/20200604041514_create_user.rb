class CreateUser < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :rank
      t.string :password_digest
      t.timestamps
    end
  end
end
