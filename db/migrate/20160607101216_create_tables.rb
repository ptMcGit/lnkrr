class CreateTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
    end

    create_table :items do |t|
      t.string :name, null: false
      t.integer :list_id, null: false
      t.date :due_date
      t.datetime :done_at
    end

    create_table :lists do |t|
      t.string :title
      t.integer :user_id
    end
  end
end
