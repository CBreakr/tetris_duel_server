class CreateUser < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :rank
      t.boolean :logged_in
      t.boolean :issued_challenge
      t.datetime :last_activity
      t.boolean :in_lobby
      t.boolean :marked_inactive
      t.string :password_digest
      t.timestamps
    end
  end
end
