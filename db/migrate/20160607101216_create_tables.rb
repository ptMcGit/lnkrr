class CreateTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :first_name
      t.string :last_name
      t.string :avatar
      t.string :location
      t.date :joined_date
    end
    #saved_links make from User.link.count

    create_table :links do |t|
      t.string :title
      t.string :url
      t.text :description
      t.datetime :timestamp
    end
    create_table :slinks do |t|
      t.integer :user_id
      t.integer :link_id
      t.integer :receiver_id
    end
      # t.datetime :done_at
  end
end
