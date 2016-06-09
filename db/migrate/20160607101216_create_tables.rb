class CreateTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
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
      # t.datetime :done_at
  end
end
